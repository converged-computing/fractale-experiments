import os
import re
import json
import pandas as pd
import seaborn as sns
import matplotlib.pyplot as plt
from pathlib import Path


class HPCResultParser:
    def __init__(self, root_dir):
        self.root_dir = Path(root_dir)
        self.data = []
        self.osu_data = []

    def parse_flux_metadata(self, content):
        """
        Parses the JSON jobspec and eventlog at the bottom of flux files.
        """
        results = {"wlm_time": None, "nodes": None}
        try:
            # Extract Jobspec
            jobspec_match = re.search(
                r"START OF JOBSPEC\n({.*?})\nSTART OF EVENTLOG", content, re.DOTALL
            )
            if jobspec_match:
                jobspec = json.loads(jobspec_match.group(1))
                results["nodes"] = jobspec["resources"][0].get("count")

            # Extract Eventlog for WLM duration
            eventlog_match = re.search(r"START OF EVENTLOG\n(.*)", content, re.DOTALL)
            if eventlog_match:
                events = [
                    json.loads(line)
                    for line in eventlog_match.group(1).strip().split("\n")
                    if line.strip()
                ]
                start = next(
                    (e["timestamp"] for e in events if e["name"] == "shell.start"), None
                )
                complete = next(
                    (e["timestamp"] for e in events if e["name"] == "complete"), None
                )
                if start and complete:
                    results["wlm_time"] = complete - start
        except Exception as e:
            pass  # Metadata missing or malformed
        return results

    def parse_app_metrics(self, app, content):
        """
        Extracts specific Figures of Merit based on the application.
        """
        if "error" and "srun" in content.lower():
            return {"error": content.strip(), "fom": None}
        if (
            "flux-job: stdin not accepted by job" in content
            and len(content.split("START")[0].strip().split("\n")) == 1
        ):
            return {"error": content.strip(), "fom": None}

        metrics = {}
        if "amg" in app:
            match = re.search(r"Figure of Merit \(FOM_2\):\s+([e\d\.\+-]+)", content)
            metrics["fom"] = float(match.group(1))

        elif "lammps" in app:
            # Performance: 0.566 timesteps/s, 1.376 Matom-step/s
            match = re.search(r"([\d\.]+)\s+(k|M|K)atom-step/s", content)
            val = float(match.group(1))
            metrics["fom"] = val if match.group(2) == "M" else val / 1000.0

            cpu_match = re.search(r"([\d\.]+)% CPU use", content)
            metrics["cpu_util"] = float(cpu_match.group(1))

            wall_match = re.search(r"Total wall time:\s+(\d+):(\d+):(\d+)", content)
            h, m, s = map(int, wall_match.groups())
            metrics["wall_time"] = h * 3600 + m * 60 + s

        elif "kripke" in app:
            grind_time = [x for x in content.split("\n") if "Grind time" in x][0].split(
                " "
            )[-2]
            metrics["fom"] = float(grind_time)
            unknowns = [x for x in content.split("\n") if "Number of unknowns" in x][
                0
            ].split(" ")[-1]
            metrics["unknowns"] = int(unknowns)

        return metrics

    def parse_osu(self, app, experiment, content, metadata):
        """
        Special handler for OSU matrix data.
        """
        lines = content.split("\n")
        for line in lines:
            if (
                line.startswith("#")
                or not line.strip()
                or "waiting" in line
                or "allocated" in line
                or "down" in line
            ):
                continue
            if line.startswith("START") or "error" in line:
                return

            print(line)
            parts = line.split()
            print(parts)
            size = int(parts[0])
            if app != "osu-latency" and size != 5:
                return
            self.osu_data.append(
                {
                    "app": app,
                    "experiment": experiment,
                    "size": size,
                    "latency": float(parts[1]),
                    **metadata,
                }
            )

    def run(self):
        """
        Run that shizz.
        """
        for path in self.root_dir.glob("**/*.out"):
            parts = path.parts
            # Structure: results / app / experiment / [opt: iter_dir] / file
            app = parts[1]
            experiment = parts[2]

            filename = path.name
            content = path.read_text()

            # Determine Iteration
            # Check if parent is a digit (iteration directory)
            iteration = None
            if len(parts) > 3 and parts[3].isdigit():
                iteration = int(parts[3])
            else:
                iter_match = re.search(r"iter-(\d+)", filename)
                iter_second_match = re.search(r"-(\d+)[].]out", filename)
                if iter_match:
                    iteration = int(iter_match.group(1))
                elif iter_second_match:
                    iteration = int(
                        iter_second_match.group(1).replace("-", "").split(".")[0]
                    )
                else:
                    raise ValueError(f"Cannot match iteration for {filename}")

            # Determine Affinity
            # Check if directory context or filename mentions affinity
            has_affinity_files = any(
                "affinity" in p.name for p in path.parent.glob("*.out")
            )
            affinity = None
            if has_affinity_files:
                affinity = "affinity" in filename

            # Determine Improve
            has_improve_files = any(
                "improve" in p.name for p in path.parent.glob("*.out")
            )
            improve = None
            if has_improve_files:
                improve = "improve" in filename

            # Determine Nodes (from filename if flux metadata fails)
            nodes = None
            if "slurm" in experiment and "flux-to-slurm" not in experiment:
                node_match = re.search(r"(\d+)-nodes", filename)
            else:
                node_match = re.search(r"nodes-(\d+)", filename)
            if "flux-to-slurm" in experiment:
                cmd_id_match = re.search(r"command-(\d+)", filename)
                if cmd_id_match:
                    cmd_id = cmd_id_match.group(1)
                    # Look for the .sh file in the top-level srun directory
                    sh_path = (
                        self.root_dir.parent
                        / "srun"
                        / f"flux-to-slurm-command-{cmd_id}.sh"
                    )
                    if sh_path.exists():
                        sh_content = sh_path.read_text()
                        if "osu_latency" in sh_content:
                            app = "osu-latency"
                        elif "osu_allreduce" in sh_content:
                            app = "osu-allreduce"
                        srun_node_match = re.search(
                            r"(?:-N|--nodes)[=\s]*(\d+)", sh_content
                        )
                        nodes = int(
                            srun_node_match.group(1)
                            .replace("-N", "")
                            .replace("--nodes", "")
                        )

            # application-<nodes>-
            elif node_match is None:
                nodes = filename.split(app)[-1].split("-")[1]
            else:
                nodes = int(node_match.group(1))
            if not nodes:
                import IPython

                IPython.embed()
                raise ValueError(f"{filename} is missing nodes")

            # Context
            context = "agent" if "flux-to-slurm" in experiment else "manual"

            metadata = {
                "app": app,
                "experiment": experiment,
                "context": context,
                "iteration": iteration,
                "affinity": affinity,
                "improve": improve,
                "nodes": int(nodes),
                "path": str(path),
            }

            # Parse specialized data
            if "osu" in app:

                self.parse_osu(app, experiment, content, metadata)
            else:
                flux_meta = self.parse_flux_metadata(content)
                app_meta = self.parse_app_metrics(app, content)

                # Update nodes if metadata found it
                if flux_meta["nodes"] and nodes is None:
                    metadata["nodes"] = flux_meta["nodes"]
                elif flux_meta["nodes"] and flux_meta["nodes"] != metadata["nodes"]:
                    raise ValueError(f"Found different counts of nodes for {filename}")
                entry = {**metadata, **app_meta}
                self.data.append(entry)

        return pd.DataFrame(self.data), pd.DataFrame(self.osu_data)


def main():
    parser = HPCResultParser("results")
    df, osu_df = parser.run()

    # Filter out rows without a FOM for scaling plots
    scaling_df = df[df["fom"].notnull()].copy()

    # Set visual style
    sns.set_theme(style="whitegrid")

    plot_results(scaling_df, osu_df)
    print("Dataframes created and plots saved.")


def plot_results(df, osu_df):
    # Scaling Plot for AMG/LAMMPS/KRIPKE
    apps = df["app"].unique()
    df.to_csv("img/scaling_data.csv")
    for app in apps:
        if "osu" in app:
            continue
        plt.figure(figsize=(9, 3))
        app_df = df[df["app"] == app]
        app_df["Variant"] = app_df.apply(
            lambda x: f"{x['experiment']} (Affinity:{x['affinity']}, Improve:{x['improve']})",
            axis=1,
        )
        variants = []
        for variant in app_df.Variant.tolist():
            experiment = variant.split(" ")[0]
            improve = ""
            affinity = ""
            if "Improve:True" in variant:
                improve = "improve (yes)"
            elif "Improve:False" in variant:
                improve = "improve (no)"

            if "Affinity:True" in variant:
                affinity = "affinity (yes)"
            elif "Improve:False" in variant:
                affinity = "affinity (no)"

            variants.append(f"{experiment} {improve} {affinity}".strip())

        # ax = sns.lineplot(data=app_df, x='nodes', y='fom', hue='Variant', marker='o', err_style="bars")
        app_df.loc[:, "Variant"] = variants
        ax = sns.barplot(
            data=app_df, x="nodes", y="fom", hue="Variant", palette="muted"
        )
        ax.set_title(f"Scaling Study for {app.capitalize()}")
        if "amg" in app:
            ax.set_ylabel("FOM Overall")
        elif "lammps" in app:
            ax.set_ylabel("M/Atom Steps Per Second")
        elif "kripke" in app:
            ax.set_ylabel("(seconds/iteration)/unknowns)")
        else:
            ax.set_ylabel("Figure of Merit (Higher/Lower app specific)")
        plt.legend(bbox_to_anchor=(1.05, 1), loc="upper left")
        plt.tight_layout()
        plt.savefig(f"img/scaling_{app}.png")

    # 2. OSU Latency Plots
    for app in osu_df["app"].unique():
        plt.figure(figsize=(10, 6))
        subset = osu_df[osu_df["app"] == app]
        ax = sns.lineplot(
            data=subset, x="size", y="latency", hue="experiment", marker="s"
        )
        ax.set_xscale("log", base=2)
        ax.set_yscale("log")
        ax.set_title(f"OSU Benchmark: {app}")
        ax.set_ylabel("Latency (us)")
        ax.set_xlabel("Message Size (Bytes)")
        plt.tight_layout()
        plt.savefig(f"img/{app}_performance.png")
    print(df.shape)
    print(osu_df.shape)
    import IPython

    IPython.embed()


if __name__ == "__main__":
    main()

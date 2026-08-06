import os
import re
import json
import pandas as pd
from scipy import stats
import seaborn as sns
import matplotlib.pyplot as plt
from pathlib import Path


# Fixed hue order and colours. Without these, seaborn derives the hue
# categories separately for each subplot (each gets its own `subset`) and
# assigns palette slots in order of appearance, so the same experiment gets
# a different colour in each panel.
#
# "deep" is seaborn's default theme palette, which is what the OSU line and
# box plots were already using, and "muted" is what the scaling bar plot was
# already using -- so these preserve the current appearance and only fix the
# panel-to-panel inconsistency.
EXPERIMENT_ORDER = ["flux", "slurm", "flux to slurm"]
EXPERIMENT_COLORS = dict(zip(EXPERIMENT_ORDER, sns.color_palette("deep", 3)))

VARIANT_ORDER = [
    "flux affinity (no)",
    "flux affinity (yes)",
    "slurm affinity (no)",
    "slurm affinity (yes)",
    "flux to slurm",
]
VARIANT_COLORS = dict(zip(VARIANT_ORDER, sns.color_palette("muted", 5)))


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
        # FIXME: "error" is a non-empty literal and therefore always truthy, so
        # this reduces to `"srun" in content.lower()` -- any output mentioning
        # srun is discarded. Left as-is so re-running reproduces the published
        # numbers; the intended test was probably:
        #   if "error" in content.lower() and "srun" in content.lower():
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
            if match:
                metrics["fom"] = float(match.group(1))

        elif "lammps" in app:
            # Performance: 0.566 timesteps/s, 1.376 Matom-step/s
            match = re.search(r"([\d\.]+)\s+(k|M|K)atom-step/s", content)
            if match:
                val = float(match.group(1))
                metrics["fom"] = val if match.group(2) == "M" else val / 1000.0

            cpu_match = re.search(r"([\d\.]+)% CPU use", content)
            if cpu_match:
                metrics["cpu_util"] = float(cpu_match.group(1))

            wall_match = re.search(r"Total wall time:\s+(\d+):(\d+):(\d+)", content)
            if wall_match:
                h, m, s = map(int, wall_match.groups())
                metrics["wall_time"] = h * 3600 + m * 60 + s

        elif "kripke" in app:
            grind_time_lines = [x for x in content.split("\n") if "Grind time" in x]
            if grind_time_lines:
                metrics["fom"] = float(grind_time_lines[0].split(" ")[-2])

            unknowns_lines = [
                x for x in content.split("\n") if "Number of unknowns" in x
            ]
            if unknowns_lines:
                metrics["unknowns"] = int(unknowns_lines[0].split(" ")[-1])

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

            parts = line.split()
            size = int(parts[0])
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
            # has_improve_files = any(
            #    "improve" in p.name for p in path.parent.glob("*.out")
            # )
            # improve = None
            # if has_improve_files:
            #   improve = "improve" in filename

            # Let's not add these - too complicated
            # if improve:
            #    continue

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
                print(f"{filename} is missing nodes")
                import IPython

                IPython.embed()

            # Context
            context = "agent" if "flux-to-slurm" in experiment else "manual"
            if experiment == "flux-to-slurm":
                experiment = "flux to slurm"
            metadata = {
                "app": app,
                "experiment": experiment,
                "context": context,
                "iteration": iteration,
                "affinity": affinity,
                # "improve": improve,
                "nodes": int(nodes),
                "path": str(path),
            }

            # Parse osu vs an app
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


def get_variant_label(row):
    """Helper to clean up variant logic and avoid original logic bugs"""
    experiment = row["experiment"]

    improve = ""
    # if row['improve'] is True or str(row['improve']) == "True":
    #    improve = "improve (yes)"
    # elif row['improve'] is False or str(row['improve']) == "False":
    #    improve = "improve (no)"

    affinity = ""
    if row["affinity"] is True or str(row["affinity"]) == "True":
        affinity = "affinity (yes)"
    elif row["affinity"] is False or str(row["affinity"]) == "False":
        affinity = "affinity (no)"

    return f"{experiment} {improve}{affinity}".strip()


def plot_results(df, osu_df):
    Path("img").mkdir(parents=True, exist_ok=True)
    df.to_csv("img/scaling_data.csv", index=False)

    # 1. Combined Scaling Plot for AMG/LAMMPS/KRIPKE
    scaling_apps = [app for app in df["app"].unique() if "osu" not in app]

    if scaling_apps:
        # Create a single figure with subplots (1 row, N columns)
        fig, axes = plt.subplots(
            1, len(scaling_apps), figsize=(6 * len(scaling_apps), 4)
        )

        # Ensure axes is iterable even if there's only 1 app
        if len(scaling_apps) == 1:
            axes = [axes]

        for i, app in enumerate(scaling_apps):
            ax = axes[i]
            app_df = df[df["app"] == app].copy()
            app_df["Variant"] = app_df.apply(get_variant_label, axis=1)
            sns.barplot(
                data=app_df,
                x="nodes",
                y="fom",
                hue="Variant",
                hue_order=VARIANT_ORDER,
                palette=VARIANT_COLORS,
                ax=ax,
            )

            ax.set_title(app.capitalize())
            if "amg" in app:
                ax.set_ylabel("FOM Overall")
            elif "lammps" in app:
                ax.set_ylabel("M/Atom Steps Per Second")
            elif "kripke" in app:
                ax.set_ylabel("(seconds/iteration)/unknowns")
            else:
                ax.set_ylabel("Figure of Merit")

            # Remove individual legends from each subplot
            if ax.get_legend() is not None:
                ax.get_legend().remove()

        # Add a single common legend to the far right of the entire figure
        handles, labels = axes[-1].get_legend_handles_labels()
        fig.legend(
            handles,
            labels,
            bbox_to_anchor=(1.01, 0.5),
            loc="center left",
            title="Variant",
            borderaxespad=0.0,
        )

        plt.tight_layout()
        # Save with bbox_inches='tight' so the external legend isn't clipped
        plt.savefig("img/scaling_combined.png", bbox_inches="tight")
        plt.savefig("img/scaling_combined.svg", bbox_inches="tight")
        plt.savefig("img/scaling_combined.pdf", bbox_inches="tight")
        plt.close()

    # OSU Latency Plots (Kept as separate plots)
    fig, axes = plt.subplots(1, 2, figsize=(16, 4))

    for i, app in enumerate(osu_df["app"].unique()):
        ax = axes[i]
        subset = osu_df[osu_df["app"] == app]
        sns.lineplot(
            ax=ax,
            data=subset,
            x="size",
            y="latency",
            hue="experiment",
            hue_order=EXPERIMENT_ORDER,
            palette=EXPERIMENT_COLORS,
            marker="s",
        )
        ax.set_xscale("log", base=2)
        ax.set_yscale("log")
        ax.set_title(f"OSU Benchmark: {app}")
        ax.set_ylabel("Latency (us)")
        ax.set_xlabel("Message Size (Bytes)")

    plt.tight_layout()
    plt.savefig(f"img/osu_performance.png", bbox_inches="tight")
    plt.savefig(f"img/osu_performance.svg", bbox_inches="tight")
    plt.savefig(f"img/osu_performance.pdf", bbox_inches="tight")
    plt.close()

    fig, axes = plt.subplots(1, 2, figsize=(16, 4))
    for i, app in enumerate(osu_df["app"].unique()):
        ax = axes[i]
        subset = osu_df[osu_df["app"] == app]
        sns.boxplot(
            ax=ax,
            data=subset,
            x="size",
            y="latency",
            hue="experiment",
            hue_order=EXPERIMENT_ORDER,
            palette=EXPERIMENT_COLORS,
        )
        ax.set_xscale("log", base=2)
        ax.set_yscale("log")
        ax.set_title(f"OSU Benchmark: {app}")
        ax.set_ylabel("Latency (us)")
        ax.set_xlabel("Message Size (Bytes)")

    plt.tight_layout()
    plt.savefig(f"img/osu_performance_box.png", bbox_inches="tight")
    plt.savefig(f"img/osu_performance_box.svg", bbox_inches="tight")
    plt.savefig(f"img/osu_performance_box.pdf", bbox_inches="tight")
    plt.close()

    print(df.shape)
    print(osu_df.shape)

    # Set PLOT_DEBUG=1 to drop into a shell here; otherwise a re-run of this
    # script would block waiting on stdin.
    if os.environ.get("PLOT_DEBUG"):
        import IPython

        IPython.embed()
    # How is lammps size 5 different?


def generate_stats_report(df, osu_df):
    """
    Direct comparison: 'flux to slurm' vs 'slurm'
    Calculates Mean/Std, % Difference, and exact P-Values.
    """
    results_path = Path("img")
    results_path.mkdir(parents=True, exist_ok=True)

    # Helper function to perform T-Test and return p-value
    def run_ttest(group1, group2):
        if len(group1) < 2 or len(group2) < 2:
            return float("nan"), "N/A"

        # Perform Welch's T-Test
        t_stat, p_val = stats.ttest_ind(group1, group2, equal_var=False)
        sig_label = "YES" if p_val < 0.05 else "no"
        return p_val, sig_label

    print("\n" + "=" * 100)
    # Added P-VALUE column to the header
    print(
        f"{'APP':<12} {'NODES':<6} {'SLURM MEAN':<12} {'SLURM STD':<12} {'FLUX MEAN':<12} {'SLURM STD':<12} {'DIFF %':<10} {'P-VALUE':<12} {'SIG?'}"
    )
    print("-" * 100)

    scaling_results = []
    for (app, nodes), group in df.groupby(["app", "nodes"]):
        flux_vals = group[group["experiment"] == "flux to slurm"]["fom"].dropna()
        slurm_vals = group[group["experiment"] == "slurm"]["fom"].dropna()

        if not flux_vals.empty and not slurm_vals.empty:
            m_flux, m_slurm = flux_vals.mean(), slurm_vals.mean()
            std_flux, std_slurm = flux_vals.std(), slurm_vals.std()
            diff_pct = ((m_flux - m_slurm) / m_slurm) * 100
            p_val, sig_label = run_ttest(flux_vals, slurm_vals)

            # Print row with p-value in scientific notation
            p_str = f"{p_val:.2e}" if not pd.isna(p_val) else "N/A"
            print(
                f"{app:<12} {nodes:<6} {m_slurm:<12.2f} {std_slurm:<12.2f} {m_flux:<12.2f} {std_flux:<12.2f} {diff_pct:<10.2f}% {p_str:<12} {sig_label}"
            )

            scaling_results.append(
                {
                    "app": app,
                    "nodes": nodes,
                    "slurm_mean": m_slurm,
                    "flux_mean": m_flux,
                    "slurm_std": std_slurm,
                    "flux_std": std_flux,
                    "diff_percent": diff_pct,
                    "p_value": p_val,
                    "significant": sig_label,
                }
            )

    pd.DataFrame(scaling_results).to_csv(
        "img/scaling_significance_report.csv", index=False
    )

    print("\n" + "=" * 100)
    print(
        f"{'OSU APP':<15} {'SLURM LAT':<12} {'SLURM STD':<12} {'FLUX LAT':<12} {'FLUX STD':<12} {'DIFF %':<10} {'P-VALUE':<12} {'SIG?'}"
    )
    print("-" * 100)

    osu_results = []

    for app, group in osu_df.groupby("app"):
        if app == "osu-allreduce":
            group = group[group["nodes"] == 5]
            group = group[group["size"] == 1048576]
        elif app == "osu-latency":
            group = group[group["size"] == 1]

        # Note, change this to flux to see difference reported in paper
        flux_vals = group[group["experiment"] == "flux to slurm"]["latency"].dropna()
        slurm_vals = group[group["experiment"] == "slurm"]["latency"].dropna()

        m_flux, m_slurm = flux_vals.mean(), slurm_vals.mean()
        std_flux, std_slurm = flux_vals.std(), slurm_vals.std()
        diff_pct = ((m_flux - m_slurm) / m_slurm) * 100
        p_val, sig_label = run_ttest(flux_vals, slurm_vals)

        p_str = f"{p_val:.2e}" if not pd.isna(p_val) else "N/A"
        print(
            f"{app:<15} {m_slurm:<12.2f} {std_slurm:<12.2f} {m_flux:<12.2f} {std_flux:<12.2f} {diff_pct:<10.2f}% {p_str:<12} {sig_label}"
        )

        osu_results.append(
            {
                "app": app,
                "size": 5,
                "slurm_mean": m_slurm,
                "flux_mean": m_flux,
                "slurm_std": std_slurm,
                "flux_std": std_flux,
                "diff_percent": diff_pct,
                "p_value": p_val,
                "significant": sig_label,
            }
        )

    pd.DataFrame(osu_results).to_csv("img/osu_significance_report.csv", index=False)

    print("=" * 100)


def main():
    parser = HPCResultParser("results")
    df, osu_df = parser.run()

    # Verify we actually have data before proceeding
    if df.empty:
        print(
            "Error: No data parsed from 'results' directory. Check your file paths and regex."
        )
        return

    # Filter out rows without a FOM for scaling plots
    scaling_df = df[df["fom"].notnull()].copy()

    # Set visual style
    sns.set_theme(style="whitegrid")

    # Run Plotting
    plot_results(scaling_df, osu_df)
    generate_stats_report(scaling_df, osu_df)

    # TODO add significant differences
    # add table / numbers to paper
    # comment on WHY different  (look at slack and data)
    # compare to agent runs n optimization study.
    # also add osu


if __name__ == "__main__":
    main()

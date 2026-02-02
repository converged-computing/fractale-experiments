import argparse
import os
import re
import json
import pandas
import asyncio
from pathlib import Path
import sys

import seaborn as sns
import matplotlib.pylab as plt
from fastmcp import Client

try:
    from rich.console import Console
    from rich.panel import Panel
    from rich.syntax import Syntax
    from rich.table import Table
    from rich.text import Text
except ImportError:
    sys.exit("Please install the 'rich' library to run this script: pip install rich")


def get_code_block(content, code_type="json"):
    """
    Parse a code block from the response

    This is a function from our agent we re-use here.
    """
    pattern = f"```(?:{code_type})?\n(.*?)```"
    match = re.search(pattern, content, re.DOTALL)
    if match:
        return match.group(1).strip()
    if content.startswith(f"```{code_type}"):
        content = content[len(f"```{code_type}") :]
    if content.startswith("```"):
        content = content[len("```") :]
    if content.endswith("```"):
        content = content[: -len("```")]
    return content.strip()


def parse_step_result(result):
    """
    Safely parses a step's 'result' field, which could be a dict,
    a JSON string, or a JSON string wrapped in a markdown code block.

    Returns a dictionary in all cases, or an empty dict on failure.
    """
    if isinstance(result, dict):
        # It's already a dictionary, so we're done.
        return result

    # Agent sometimes gives null result without quotes
    # This means it decided to not transform (not a batch script)
    result = result.replace(":null", ':"null"')

    # It's a string, so first, strip any markdown code block formatting.
    content = get_code_block(result, code_type="json")
    try:
        return json.loads(content)
    # When we have an unsuccessful finish reason (not from LLM) just a string
    except:
        return content


# https://gofastmcp.com/clients/tools
async def is_valid(script):
    # The client automatically selects the correct transport (e.g., STDIO, HTTP, In-memory)
    # based on the argument provided.
    async with Client("http://localhost:8089/mcp") as client:
        # Optional: List available tools
        tools = await client.list_tools()
        print("Available tools:", tools)

        # Call the tool "add" with specific arguments
        result = await client.call_tool("validate_flux_jobspec", {"content": script})

        # Access the structured result data
        print("Result data:", result.data)
        # Access the raw text content
        print("Result text:", result.content[0].text)
        return result


def parse_result_file(file_path: Path) -> dict:
    """
    Opens and parses a single JSON log file, handling nested JSON.
    Returns a dictionary with the key information needed for display.
    """
    with open(file_path, "r") as f:
        data = json.load(f)

    plan = data.get("plan", {})
    transform_inputs = plan.get("steps", [{}])[0].get("inputs", {})

    from_manager = transform_inputs.get("from_manager")
    to_manager = transform_inputs.get("to_manager")
    original_script = transform_inputs.get("script")

    steps = data.get("steps", [])
    transform_step = next((s for s in steps if s.get("step") == "transform"), None)
    validate_step = next((s for s in steps if s.get("step") == "validate"), None)

    if not all(
        [from_manager, to_manager, original_script, transform_step, validate_step]
    ):
        raise ValueError(
            "Log file is missing required fields (plan, steps, or inputs)."
        )

    # The result fields can be nested JSON strings, and inconsistent. Yuck
    try:
        transform_data = parse_step_result(transform_step.get("result", "{}"))
        validation_data = parse_step_result(validate_step.get("result"))
        generated_script = transform_data.get("jobspec")
    except (json.JSONDecodeError, AttributeError):
        raise

    except Exception:
        # This largely should not happen - inspect the above manually if it does
        print("There was a problem.")
        import IPython

        IPython.embed()

    if isinstance(validation_data, dict):
        is_valid = validation_data.get("valid", False)
        errors = validation_data.get("errors", [])
        reasons = validation_data.get("reasons", [])
        issues = validation_data.get("issues", [])

    else:
        is_valid = False
        reasons = [validation_data] if validation_data else []
        errors = "See reasons"
        issues = []

    return {
        "source_file": file_path.name,
        "from_manager": from_manager,
        "to_manager": to_manager,
        "original_script": original_script,
        "generated_script": generated_script,
        "is_valid": is_valid,
        "errors": errors,
        "reasons": reasons,
        "issues": issues,
    }


here = os.path.dirname(__file__)
root = os.path.dirname(here)


def get_parser():
    parser = argparse.ArgumentParser(
        description="Review agentic transformation results."
    )
    parser.add_argument(
        "--input",
        help="Input directory containing the JSON result logs.",
        default=os.path.join(root, "results"),
    )
    return parser


def add_agreement_category(df):
    """Adds a new column to the DataFrame to categorize the agreement type."""

    def get_category(row):
        flux_valid = row["flux_validator"]
        llm_valid = row["llm_validator"]

        if flux_valid and llm_valid:
            return "True Positive (Agreed Valid)"
        if not flux_valid and not llm_valid:
            return "True Negative (Agreed Invalid)"
        if not flux_valid and llm_valid:
            return "False Positive (LLM Wrongly Validated)"
        if flux_valid and not llm_valid:
            return "False Negative (LLM Wrongly Invalidated)"

    df["agreement_category"] = df.apply(get_category, axis=1)
    return df


def main():
    parser = get_parser()
    args = parser.parse_args()

    path = Path(args.input)
    if not path.exists() or not path.is_dir():
        sys.exit(f"Error: Input directory not found: {path}")

    # There weren't any issues for to flux conversions
    issues = []
    all_files = sorted(list(path.rglob("*-result.json")))
    for i, file_path in enumerate(all_files):
        try:
            result_data = parse_result_file(file_path)
        except (AttributeError, json.JSONDecodeError) as e:
            continue
        issues += result_data.get('issues')

    console = Console()
    json_files = sorted(list(path.rglob("*flux-result.json")))
    print(f"Found {len(json_files)} conversions to Flux")

    if not json_files:
        console.print(f"[bold red]No .json result files found in '{path}'.[/bold red]")
        sys.exit()

    # Store counts of things.
    # This is what the LLM said vs. what Flux validator says
    df = pandas.DataFrame(
        columns=["filename", "from_manager", "flux_validator", "llm_validator"]
    )

    # Also keep track of failed directives
    failed = {}
    reasons = []
    idx = 0

    # Failed parsing
    failed_generation = {"json_decode_error": 0}

    for i, file_path in enumerate(json_files):
        console.clear()

        header = f"Reviewing Result {i + 1} of {len(json_files)}"
        console.rule(f"[bold cyan]{header}[/bold cyan]")

        try:
            result_data = parse_result_file(file_path)
        except (AttributeError, json.JSONDecodeError) as e:
            failed_generation["json_decode_error"] += 1
            continue

        except Exception as e:
            console.print(
                Panel(
                    f"Could not parse or display file: {file_path}\nError: {e}",
                    title="[bold red]ERROR[/bold red]",
                    border_style="red",
                )
            )
            import IPython

            IPython.embed()

        assert result_data["to_manager"] == "flux"
        result = asyncio.run(is_valid(result_data["generated_script"]))
        reasons += result_data.get("reasons", [])
        issues += result_data.get("issues", [])

        # Add to count
        errors = result.data.get("errors", [])
        if errors:
            for directive in errors[0].split("\n")[1:]:
                if directive not in failed:
                    failed[directive] = 0
                failed[directive] += 1

        # flux validator direct result
        flux_valid = result.data["valid"]
        df.loc[idx, :] = [
            file_path,
            result_data["from_manager"],
            flux_valid,
            result_data["is_valid"],
        ]
        idx += 1

    output_directory = os.path.join(root, "img")
    os.makedirs(output_directory, exist_ok=True)
    write_json(reasons, os.path.join(root, "analysis", "reasons.json"))
    write_json(failed, os.path.join(root, "analysis", "failed-validation.json"))
    write_json(issues, os.path.join(root, "analysis", "issues.json"))

    print("Generating Plots")
    df = add_agreement_category(df)
    plot_overall_agreement(df, f"{output_directory}/1_overall_agreement_breakdown.png")
    plot_agreement_by_manager(df, f"{output_directory}/2_agreement_by_manager.png")
    plot_agreement_by_manager_percentage(
        df, f"{output_directory}/3_agreement_by_manager_percentage.png"
    )

    # Filter to just slurm
    df = df[df["from_manager"] == "slurm"]
    title = "Agreement between Flux Validator and LLM Validator (Slurm)"
    plot_agreement_by_manager(df, f"{output_directory}/4_agreement_slurm.png")
    plot_agreement_by_manager_percentage(
        df, f"{output_directory}/5_agreement_slurm.png"
    )
    plot_overall_agreement(
        df, f"{output_directory}/6_overall_agreement_breakdown_slurm.png", title=title
    )

    print("\nAnalysis complete.")
    print(f"Plots saved in the '{output_directory}' directory.")


def write_json(content, outfile):
    with open(outfile, "w") as fd:
        fd.write(json.dumps(content, indent=4))


def plot_overall_agreement(df, output_path, title=None):
    """
    Creates a single stacked bar plot showing the overall breakdown of agreement categories.
    """
    plt.style.use("seaborn-v0_8-whitegrid")
    fig, ax = plt.subplots(figsize=(10, 7))

    # Define a clear color palette for the four categories
    palette = {
        "True Positive (Agreed Valid)": "#4CAF50",  # Green
        "True Negative (Agreed Invalid)": "#2196F3",  # Blue
        "False Positive (LLM Wrongly Validated)": "#FFC107",  # Amber
        "False Negative (LLM Wrongly Invalidated)": "#F44336",  # Red
    }

    # Count the occurrences of each category
    counts = df["agreement_category"].value_counts()

    # Plot as a horizontal bar chart for readability
    counts.plot(
        kind="barh", ax=ax, color=[palette.get(cat, "#9E9E9E") for cat in counts.index]
    )

    title = title or "Overall Agreement between Flux Validator and LLM Validator"
    ax.set_title(title, fontsize=16, pad=20)
    ax.set_xlabel("Number of Jobs", fontsize=12)
    ax.set_ylabel("Agreement Category", fontsize=12)

    # Add labels to the bars
    for i, (cat, count) in enumerate(counts.items()):
        ax.text(count + 2, i, str(count), va="center", fontsize=11)

    plt.tight_layout()
    plt.savefig(output_path)
    print(f"Saved plot: {output_path}")
    plt.close()


def plot_overall_agreement_percentage(df, output_path, title=None):
    """
    Creates a single stacked bar plot showing the overall breakdown of agreement
    categories as percentages.
    """
    plt.style.use("seaborn-v0_8-whitegrid")
    fig, ax = plt.subplots(figsize=(10, 7))

    # Define a clear color palette for the four categories
    palette = {
        "True Positive (Agreed Valid)": "#4CAF50",  # Green
        "True Negative (Agreed Invalid)": "#2196F3",  # Blue
        "False Positive (LLM Wrongly Validated)": "#FFC107",  # Amber
        "False Negative (LLM Wrongly Invalidated)": "#F44336",  # Red
    }

    # --- MODIFIED: Calculate percentages instead of raw counts ---
    if df.empty:
        print("Cannot plot overall agreement: DataFrame is empty.")
        plt.close()
        return

    percentages = df["agreement_category"].value_counts(normalize=True).mul(100)

    # Plot as a horizontal bar chart for readability
    percentages.plot(
        kind="barh",
        ax=ax,
        color=[palette.get(cat, "#9E9E9E") for cat in percentages.index],
    )

    title = title or "Overall Agreement between Flux Validator and LLM Validator"
    ax.set_title(title, fontsize=16, pad=20)

    ax.set_xlabel("Percentage of Total Jobs (%)", fontsize=12)
    ax.set_ylabel("Agreement Category", fontsize=12)

    for i, (cat, percentage) in enumerate(percentages.items()):
        label_text = f"{percentage:.1f}%"
        ax.text(percentage + 1, i, label_text, va="center", fontsize=11)

    # Give some space for the labels
    ax.set_xlim(right=max(105, percentages.max() + 10))

    plt.tight_layout()
    plt.savefig(output_path)
    print(f"Saved plot: {output_path}")
    plt.close()


def plot_agreement_by_manager(df, output_path):
    """
    Creates faceted bar charts showing the agreement breakdown for each 'from_manager'.
    """
    plt.style.use("seaborn-v0_8-whitegrid")

    # Define the same palette as the overall plot for consistency
    palette = {
        "True Positive (Agreed Valid)": "#4CAF50",
        "True Negative (Agreed Invalid)": "#2196F3",
        "False Positive (LLM Wrongly Validated)": "#FFC107",
        "False Negative (LLM Wrongly Invalidated)": "#F44336",
    }

    # Use seaborn's catplot to create faceted plots
    g = sns.catplot(
        data=df,
        y="agreement_category",
        col="from_manager",
        kind="count",
        palette=palette,
        order=[  # Use a fixed order for the y-axis
            "True Positive (Agreed Valid)",
            "True Negative (Agreed Invalid)",
            "False Positive (LLM Wrongly Validated)",
            "False Negative (LLM Wrongly Invalidated)",
        ],
    )

    g.set_axis_labels("Number of Jobs", "Agreement Category")
    g.set_titles("Source: {col_name}")

    plt.savefig(output_path)
    print(f"Saved plot: {output_path}")
    plt.close()


def plot_agreement_by_manager_percentage(df, output_path):
    """
    Creates faceted bar charts (percentages) showing agreement breakdown for each 'from_manager'.
    """
    plt.style.use("seaborn-v0_8-whitegrid")
    palette = {
        "True Positive (Agreed Valid)": "#4CAF50",
        "True Negative (Agreed Invalid)": "#2196F3",
        "False Positive (LLM Wrongly Validated)": "#FFC107",
        "False Negative (LLM Wrongly Invalidated)": "#F44336",
    }

    # Calculate percentages
    pct_df = (
        df.groupby("from_manager")["agreement_category"]
        .value_counts(normalize=True)
        .mul(100)
        .rename("percentage")
        .reset_index()
    )

    g = sns.catplot(
        data=pct_df,
        x="percentage",
        y="agreement_category",
        col="from_manager",
        kind="bar",
        palette=palette,
        height=6,
        aspect=1,
        order=[
            "True Positive (Agreed Valid)",
            "True Negative (Agreed Invalid)",
            "False Positive (LLM Wrongly Validated)",
            "False Negative (LLM Wrongly Invalidated)",
        ],
    )

    g.fig.suptitle(
        "Validator Agreement (Percentage) by Source Manager", y=1.03, fontsize=16
    )
    g.set_axis_labels("Percentage of Jobs (%)", "Agreement Category")
    g.set_titles("Source: {col_name}")
    g.tight_layout(rect=[0, 0, 1, 0.97])

    plt.savefig(output_path)
    print(f"Saved plot: {output_path}")
    plt.close()


if __name__ == "__main__":
    main()

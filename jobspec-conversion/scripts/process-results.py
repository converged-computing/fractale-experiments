import argparse
import os
import re
import json
from pathlib import Path
import sys

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns


def classify_error(errors):
    """
    Takes a list of error messages from the validation step and returns
    a high-level category for the failure.
    """
    error = " ".join(errors).lower()

    # We can come up with categories here
    if "directive" in error:
        return "Directive Syntax/Format Error"
    if "expected" in error and "found" in error:
        return "Parsing/Structural Error"
    if "validation failed" in error:
        return "Generic Validation Failure"
    if "key" in error or "attribute" in error:
        return "Missing or Invalid Attribute"
    
    return "Other"


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
    Safely parses a step result field, which could be a dict,
    a JSON string, or a JSON string wrapped in a markdown code block.
    Maybe could be improved with better prompting.
    """
    if isinstance(result, dict):
        # It's already a dictionary, so we're done.
        return result

    # It's a string, so first, strip any markdown code block formatting.
    content = get_code_block(result, code_type="json")
    try:
        return json.loads(content)
    # When we have an unsuccessful finish reason (not from LLM) just a string
    except:
        return content


def load_and_parse_results(logs_dir: Path) -> pd.DataFrame:
    """
    Recursively finds all .json log files in a directory, parses them,
    and returns a clean pandas DataFrame.
    """
    records = []
    json_files = list(logs_dir.rglob("*.json"))
    print(f"Found {len(json_files)} result files to analyze.")

    for file_path in json_files:
        # Summarized / synthesis of results
        if os.path.basename(file_path) == "experiment-summary.json":
            continue
        with open(file_path, 'r') as f:
            try:
                data = json.load(f)
            except json.JSONDecodeError:
                print(f"Warning: Skipping malformed JSON file: {file_path}")
                continue

        plan = data.get("plan", {})
        transform_inputs = plan.get("steps", [{}])[0].get("inputs", {})
        
        from_manager = transform_inputs.get("from_manager")
        to_manager = transform_inputs.get("to_manager")
        
        if not from_manager or not to_manager:
            continue

        # The steps contain the results
        # We probably here want to assess breakdown of tool calling (e.g., frequency)
        # It *should* see the name of the validation function and only use for flux...
        steps = data.get("steps", [])
        transform_step = next((s for s in steps if s.get("step") == "transform"), None)
        validate_step = next((s for s in steps if s.get("step") == "validate"), None)

        if not transform_step or not validate_step:
            continue

        # Results are nested JSON strings, so we need to parse them
        try:
            transform_result = parse_step_result(transform_step.get("result", "{}"))
            # Parse the nested JSON string if it's a string, otherwise use it directly
            transform_data = json.loads(transform_result) if isinstance(transform_result, str) else transform_result

            # Do the same for the validation step
            validate_result = parse_step_result(validate_step.get("result", "{}"))
            validation_data = json.loads(validate_result) if isinstance(validate_result, str) else validate_result

        except (json.JSONDecodeError, TypeError):
            continue

        # extract the final validity and errors from the parsed data
        is_valid = validation_data.get("valid", False)
        errors = validation_data.get("errors", [])
        
        records.append({
            "source_file": file_path.name,
            "from_manager": from_manager,
            "to_manager": to_manager,
            "transformation_type": f"{from_manager} -> {to_manager}",
            "transform_duration": transform_step.get("duration"),
            "validate_duration": validate_step.get("duration"),
            "is_valid": is_valid,
            "errors": errors,
        })
        
    df = pd.DataFrame(records)
    
    # apply the error classifier to create a new column
    df['error_category'] = df.apply(
        lambda row: classify_error(row['errors']) if not row['is_valid'] else None,
        axis=1
    )
    return df


def plot_valid_invalid_breakdown(df: pd.DataFrame, output_dir: Path):
    """
    Creates a stacked bar chart of valid vs. invalid counts, for
    transformations targeting Flux.
    """
    plt.style.use('seaborn-v0_8-whitegrid')
    _, ax = plt.subplots(figsize=(12, 7))

    flux_target_df = df[df['to_manager'] == 'flux'].copy()
    
    if flux_target_df.empty:
        print("No 'to_manager=flux' results found to plot for validation breakdown.")
        plt.close()
        return

    # create a summary table for plotting
    summary = flux_target_df.groupby(['transformation_type', 'is_valid']).size().unstack(fill_value=0)
    summary.rename(columns={True: 'Valid', False: 'Invalid'}, inplace=True)    
    summary.plot(kind='bar', stacked=True, color=['#4CAF50', '#F44336'], ax=ax, rot=45)

    ax.set_title('Flux Transformation Success vs. Failure by Type', fontsize=16, pad=20)
    ax.set_xlabel('Transformation Type', fontsize=12)
    ax.set_ylabel('Number of Jobs', fontsize=12)
    ax.legend(title='Validation Status')
    plt.tight_layout()
    
    output_path = output_dir / "1_valid_vs_invalid_flux_breakdown.png"
    plt.savefig(output_path)
    print(f"Saved plot: {output_path}")
    plt.close()

def plot_error_distribution(df: pd.DataFrame, output_dir: Path):
    """
    Creates a pie chart showing the distribution of error categories for
    failed transformations (only for transformations to Flux).
    """
    failed_df = df[(df['is_valid'] == False) & (df['to_manager'] == 'flux')].copy()
    if failed_df.empty:
        print("No Flux-targeted failures to plot for error distribution.")
        return

    error_counts = failed_df['error_category'].value_counts()
    
    fig, ax = plt.subplots(figsize=(10, 10))
    ax.pie(error_counts, labels=error_counts.index, autopct='%1.1f%%', startangle=90,
           pctdistance=0.85, colors=sns.color_palette("pastel"))
    
    # draw a circle at the center to make it a donut chart
    # He drew a circle that shut me out
    # Heretic rebel, a thing to flout
    # But joy and I had the wit to win.
    # We drew a circle that took him in.
    centre_circle = plt.Circle((0,0),0.70,fc='white')
    fig.gca().add_artist(centre_circle)

    ax.set_title('Distribution of Failure Reasons for Flux Transformations', fontsize=16, pad=20)
    plt.tight_layout()

    output_path = output_dir / "2_error_category_flux_distribution.png"
    plt.savefig(output_path)
    print(f"Saved plot: {output_path}")
    plt.close()

def plot_average_duration(df: pd.DataFrame, output_dir: Path):
    """
    Creates a bar chart of the average transformation duration per type.
    """
    avg_duration = df.groupby('transformation_type')['transform_duration'].mean().sort_values()
    
    _, ax = plt.subplots(figsize=(12, 7))
    avg_duration.plot(kind='barh', ax=ax, color=sns.color_palette("viridis", len(avg_duration)))

    ax.set_title('Average Transformation Duration', fontsize=16, pad=20)
    ax.set_xlabel('Average Duration (seconds)', fontsize=12)
    ax.set_ylabel('Transformation Type', fontsize=12)
    plt.tight_layout()
    
    output_path = output_dir / "3_average_duration.png"
    plt.savefig(output_path)
    print(f"Saved plot: {output_path}")
    plt.close()


here = os.path.dirname(__file__)
root = os.path.dirname(here)

def get_parser():
    parser = argparse.ArgumentParser(description="Analyze Agentic Transformation Results")
    parser.add_argument(
        "--input",
        help="Input directory containing the JSON result logs.",
        default=os.path.join(root, "results")
    )
    parser.add_argument(
        "--output-dir",
        help="Directory to save plots and summary data.",
        default="analysis",
    )
    return parser

def main():
    parser = get_parser()
    args = parser.parse_args()

    input_path = Path(args.input)
    output_path = Path(args.output_dir)
    if not input_path:
        sys.exit("You must define the --input path")

    if not input_path.exists() or not input_path.is_dir():
        sys.exit(f"Error: Input directory not found: {input_path}")

    output_path.mkdir(exist_ok=True)
    
    # load data
    df = load_and_parse_results(input_path)
    if df.empty:
        sys.exit("No valid result files found. Exiting.")

    # save the processed data for further inspection
    df.to_csv(output_path / "processed_results.csv", index=False)
    print(f"Saved processed data to: {output_path / 'processed_results.csv'}")
    
    # filter for metrics that are Flux-specific
    # we are only validating currently for flux
    flux_target_df = df[df['to_manager'] == 'flux'].copy()

    # summary metrics
    print("\nSummary Metrics (for transformations to Flux)")
    if not flux_target_df.empty:
        total_jobs = len(flux_target_df)
        valid_jobs = flux_target_df['is_valid'].sum()
        success_rate = (valid_jobs / total_jobs) * 100 if total_jobs > 0 else 0
        print(f"Overall Flux Validation Success Rate: {valid_jobs} / {total_jobs} ({success_rate:.2f}%)")
        
        print("\nSuccess Rate by Transformation Type (to Flux):")
        print(flux_target_df.groupby('transformation_type')['is_valid'].value_counts(normalize=True).unstack().fillna(0))
        
        print("\nFailure Reason Counts (for Flux jobs):")
        print(flux_target_df[flux_target_df['is_valid'] == False]['error_category'].value_counts())
    else:
        print("No transformations to Flux were found to analyze for validity.")
    
    # plotting stuff
    print("\nGenerating Plots")
    plot_valid_invalid_breakdown(df, output_path)
    plot_error_distribution(df, output_path)
    plot_average_duration(df, output_path)    
    print("\nAnalysis complete.")

if __name__ == "__main__":
    main()
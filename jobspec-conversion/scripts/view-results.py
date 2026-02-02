import argparse
import os
import re
import json
from pathlib import Path
import sys

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
    result = result.replace(':null', ':"null"')

    # It's a string, so first, strip any markdown code block formatting.
    content = get_code_block(result, code_type="json")
    try:
        return json.loads(content)
    # When we have an unsuccessful finish reason (not from LLM) just a string
    except:
        return content

def parse_result_file(file_path: Path) -> dict:
    """
    Opens and parses a single JSON log file, handling nested JSON.
    Returns a dictionary with the key information needed for display.
    """
    with open(file_path, 'r') as f:
        data = json.load(f)

    plan = data.get("plan", {})
    transform_inputs = plan.get("steps", [{}])[0].get("inputs", {})
    
    from_manager = transform_inputs.get("from_manager")
    to_manager = transform_inputs.get("to_manager")
    original_script = transform_inputs.get("script")

    steps = data.get("steps", [])
    transform_step = next((s for s in steps if s.get("step") == "transform"), None)
    validate_step = next((s for s in steps if s.get("step") == "validate"), None)

    if not all([from_manager, to_manager, original_script, transform_step, validate_step]):
        raise ValueError("Log file is missing required fields (plan, steps, or inputs).")

    # The result fields can be nested JSON strings, and inconsistent. Yuck
    try:
        transform_data = parse_step_result(transform_step.get("result", "{}"))
        validation_data = parse_step_result(validate_step.get("result"))
    except:
        # This largely should not happen - inspect the above manually if it does
        import IPython 
        IPython.embed()

    generated_script = transform_data.get("jobspec")
    if isinstance(validation_data, dict):
        is_valid = validation_data.get("valid", False)
        errors = validation_data.get("errors", [])
        reasons = validation_data.get("reasons", [])
    else:
        is_valid = False
        reasons = [validation_data] if validation_data else []
        errors = "See reasons"

    return {
        "source_file": file_path.name,
        "from_manager": from_manager,
        "to_manager": to_manager,
        "original_script": original_script,
        "generated_script": generated_script,
        "is_valid": is_valid,
        "errors": errors,
        "reasons": reasons,
    }


def display_comparison(console: Console, result: dict):
    """
    Uses the rich library to display a single transformation result.
    """
    meta_table = Table(show_header=False, box=None, padding=(0, 2))
    meta_table.add_column(style="magenta")
    meta_table.add_column()

    meta_table.add_row("Source File:", result["source_file"])
    meta_table.add_row("Transform:", f"{result['from_manager']} -> {result['to_manager']}")

    # Noop vs. valid or invalid
    invalid = False
    if result['generated_script'] == "null":
        result['generated_script'] = None
        validation_text = Text("Noop", style="bold purple")
        invalid = True
    else:
        validation_text = Text("Valid", style="bold green") if result["is_valid"] else Text("Invalid", style="bold red")
    meta_table.add_row("Status:", validation_text)

    import IPython 
    IPython.embed()
    if result["errors"]:
        error_text = "\n".join(result["errors"])
        meta_table.add_row("Errors:", Text(error_text, style="red"))
        
    # original script
    if len(result['original_script']) > 500:
        result['original_script'] = result['generated_script'][:500]

    original_syntax = Syntax(result["original_script"], "bash", theme="monokai", line_numbers=True)
    console.print(Panel(meta_table, title="[yellow]Summary[/yellow]", border_style="yellow"))
    console.print(Panel(original_syntax, title="[blue]Original Script[/blue]", border_style="blue", padding=(1, 2)))

    # generated script
    border_style = "green" if result["is_valid"] else "red"

    # Easier to just look at top
    if not invalid:
        if len(result['generated_script']) > 500:
            result['generated_script'] = result['generated_script'][:500]
        if result["generated_script"]:
            generated_syntax = Syntax(result["generated_script"], "bash", theme="monokai", line_numbers=True)
            console.print(Panel(generated_syntax, title=f"[{border_style}]Generated Script[/{border_style}]", border_style=border_style, padding=(1, 2)))
        else:
            console.print(Panel("[dim]No jobspec was generated in the transform step.[/dim]", title="[red]Generated Script[/red]", border_style="red"))

    # display llm reasons if not valid
    # note to others: we can look at these and figure out how to make it better
    if not result["is_valid"] and result["reasons"]:
        reasons_text = "\n".join(f"- {reason}" for reason in result["reasons"])
        console.print(Panel(
            Text(reasons_text),
            title="[bold purple]LLM Validation Reasons[/bold purple]",
            border_style="purple",
            padding=(1, 2)
        ))
    
here = os.path.dirname(__file__)
root = os.path.dirname(here)


def get_parser():
    parser = argparse.ArgumentParser(description="Review agentic transformation results.")
    parser.add_argument(
        "--input",
        help="Input directory containing the JSON result logs.",
        default=os.path.join(root, "results")
    )
    return parser

def main():
    parser = get_parser()
    args = parser.parse_args()

    path = Path(args.input)
    if not path.exists() or not path.is_dir():
        sys.exit(f"Error: Input directory not found: {path}")

    console = Console()
    json_files = sorted(list(path.rglob("*.json")))

    if not json_files:
        console.print(f"[bold red]No .json result files found in '{path}'.[/bold red]")
        sys.exit()

    for i, file_path in enumerate(json_files):
        console.clear()
        
        header = f"Reviewing Result {i + 1} of {len(json_files)}"
        console.rule(f"[bold cyan]{header}[/bold cyan]")
        
        try:
            result_data = parse_result_file(file_path)
            display_comparison(console, result_data)
        except Exception as e:
            console.print(Panel(f"Could not parse or display file: {file_path}\nError: {e}", title="[bold red]ERROR[/bold red]", border_style="red"))

        # --- Wait for user to press Enter ---
        if i < len(json_files) - 1:
            console.print("\n[bold]Press Enter to proceed to the next result...[/bold]", justify="center")
            input()
        else:
            console.print("\n[bold green]End of results. ✨[/bold green]", justify="center")

if __name__ == "__main__":
    main()
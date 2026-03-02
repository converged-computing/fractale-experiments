# JobSpec Conversion

This includes our open source [jobspec database](https://github.com/converged-computing/jobspec-database) and is an updated variant of early experiments in [jobspec-conversion](https://github.com/converged-computing/jobspec-conversion).

## Fractale (Agentic)

Let's use agents (of different backends) to do the translation. The general strategy is that we can deploy different servers (e.g., serving different kinds of validators or backed by different workload managers) but vary the environment variables for fractale-mcp that select the model backend. You'll need to export credentials / model information for different setups. The server setup and tools may also vary based on the setup. You will likely need to generate a function-specific file in [servers](servers). 

### General Setup

We first need to start the server with the translation prompt and validation tool.
These setup steps are used regardless of the model. I am doing this in a .devcontainer, and cloning to a temporary spot. Install the fractale-mcp library:

```bash
git clone -b experiment-tweaks https://github.com/compspec/fractale-mcp /tmp/fractale-mcp
pip install -e /tmp/fractale-mcp[all] --break-system-packages
pip install IPython mcp-serve colorama flux-mcp --break-system-packages
```

### Gemini

This example will show the Flux setup, meaning we have a flux validation tool and run the server alongside a Flux handle. I am using the local [.devcontainer](.devcontainer) to do this. In the container, after [setup](#setup), 
start a flux instance.

```bash
flux start
```

We will need to start the server and add the validation functions and prompt. Start the server with the functions and prompt we need:

```bash
mcpserver start --config ./servers/flux-gemini.yaml
```

In a different terminal, export your API key:

```bash
export GEMINI_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

And then run the experiment with a native State Machine, Flux, and Gemini. The plan (the original `transform-retry.yaml` is generated programatically in the script).

```bash
# here is how I generated testing data
python3 scripts/run-experiment.py --output ./results/gemini --limit 10

# defaults to --input ./data, no limit
python scripts/run-experiment.py --output ./results/gemini
```

That will generate conversions of jobspecs to and from a log of managers, and having the agents do some aspect of validation. Since we want a definitive answer, let's filter down to the "to flux" results and validate with our validator. With the server still running, we can use the call tool endpoint to do that.

```bash
# still running...
mcpserver start --config ./servers/flux-gemini.yaml

# More dependencies
pip install seaborn pandas matplotlib --break-system-packages

# This calls a tool endpoint and generates plots
python3 scripts/validate-flux.py
```

Note that the [analysis/issues.json]([analysis/issues.json) were empty for to flux conversions only, but I've parsed for all conversion types so we can look at.
Note from Vanessa: since we now enforce it finishes valid, these numbers should be the same, except maybe for cases when we failed up to max tries.

## Notes

- TODO: V: need to re-run 100/200 samples with updated orchestration. I think we are going to do a lot better.
- Need a differ to look at same manager translations and figure out if anything changed.
- Group based on complexity.

## Results

We have a script to visualize:

```bash
pip install rich --break-system-packages
python3 ./scripts/view-results.py
```

Process results.

```bash
pip install matplotlib pandas seaborn --break-system-packages
python3 ./scripts/process-results.py
```

Here is the first round testing (before refactor)

```console
Found 401 result files to analyze.
Saved processed data to: analysis/processed_results.csv

Summary Metrics (for transformations to Flux)
Overall Flux Validation Success Rate: 100 / 161 (62.11%)

Success Rate by Transformation Type (to Flux):
is_valid                False     True 
transformation_type                    
cobalt -> flux       0.500000  0.500000
lsf -> flux          0.583333  0.416667
pbs -> flux          0.687500  0.312500
slurm -> flux        0.265487  0.734513

Failure Reason Counts (for Flux jobs):
error_category
Directive Syntax/Format Error    41
Parsing/Structural Error         12
Other                             8
Name: count, dtype: int64

Generating Plots
Saved plot: analysis/1_valid_vs_invalid_flux_breakdown.png
Saved plot: analysis/2_error_category_flux_distribution.png
Saved plot: analysis/3_average_duration.png

Analysis complete.
```

And after:

```
Found 173 result files to analyze.
Attempt value counts:
attempts
1    133
2     17
5     16
3      4
4      2

Summary Metrics (for transformations to Flux)
Overall Flux Validation Success Rate: 70 / 86 (81.40%)

Success Rate by Transformation Type (to Flux):
is_valid                False     True 
transformation_type                    
cobalt -> flux       0.000000  1.000000
flux -> flux         0.000000  1.000000
lsf -> flux          0.375000  0.625000
pbs -> flux          0.133333  0.866667
slurm -> flux        0.183333  0.816667

Failure Reason Counts (for Flux jobs):
error_category
Directive Syntax/Format Error    15
Other                             1
Name: count, dtype: int64

Generating Plots
Saved plot: analysis/1_valid_vs_invalid_flux_breakdown.png
Saved plot: analysis/2_error_category_flux_distribution.png
Saved plot: analysis/3_average_duration.png

Analysis complete.
```

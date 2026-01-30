# JobSpec Conversion

This includes our open source [jobspec database](https://github.com/converged-computing/jobspec-database) and is an updated variant of early experiments in [jobspec-conversion](https://github.com/converged-computing/jobspec-conversion).

## Fractale (Agentic)

Let's use agents (of different backends) to do the translation. The general strategy is that we can deploy different servers (e.g., serving different kinds of validators or backed by different workload managers) but vary the environment variables for fractale-mcp that select the model backend.

Note that for the engine, autogen is hard-coded, but you'll need to export credentials / model information for different setups. The server setup and tools may also vary based on the setup. You will likely need to generate a function-specific file in [servers](servers). 

### General Setup

We first need to start the server with the translation prompt and validation tool.
These setup steps are used regardless of the model. I am doing this in a .devcontainer, and cloning to a temporary spot. Install the fractale-mcp library:

```bash
git clone -b experiment-tweaks https://github.com/compspec/fractale-mcp /tmp/fractale-mcp
pip install -e /tmp/fractale-mcp[all] --break-system-packages
pip install IPython mcp-serve colorama --break-system-packages
```

### Gemini

This example will show the Flux setup, meaning we have a flux validation tool and run the server alongside a Flux handle. I am using the local [.devcontainer](.devcontainer) to do this. In the container, after [setup](#setup), install `flux-mcp`:

```bash
# This is with experiment changes WIP
git clone -b experiment-tweaks https://github.com/converged-computing/flux-mcp /tmp/flux-mcp
pip install /tmp/flux-mcp --break-system-packages
```

Then start a flux instance.

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

And then run the experiment with AutoGen, Flux, and Gemini. The plan (the original `transform-jobspec.yaml` is generated programatically in the script).

```bash
# here is how I generated testing data
python3 scripts/run-experiment.py --output ./results/gemini --limit 10

# defaults to --input ./data, no limit
python scripts/run-experiment.py --output ./results/gemini
```

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
Here is my small sample (still testing)

```console
Found 21 result files to analyze.
Saved processed data to: analysis/processed_results.csv

Summary Metrics (for transformations to Flux)
Overall Flux Validation Success Rate: 6 / 9 (66.67%)

Success Rate by Transformation Type (to Flux):
is_valid                False     True 
transformation_type                    
pbs -> flux          0.500000  0.500000
slurm -> flux        0.285714  0.714286

Failure Reason Counts (for Flux jobs):
error_category
Directive Syntax/Format Error    2
Other                            1
Name: count, dtype: int64

Generating Plots
Saved plot: analysis/1_valid_vs_invalid_flux_breakdown.png
Saved plot: analysis/2_error_category_flux_distribution.png
Saved plot: analysis/3_average_duration.png

Analysis complete
```

I am currently looking at a sample of testing data to debug / work on the setup before running an initial experiment.

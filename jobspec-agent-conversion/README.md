# Jobspec Agent Conversion

Let's have the agent convert our database, but with the looping agent.

## Fractale (Agentic)

Let's use agents (of different backends) to do the translation. The general strategy is that we can deploy different servers (e.g., serving different kinds of validators or backed by different workload managers) but vary the environment variables for fractale that select the model backend. You'll need to export credentials / model information for different setups. The server setup and tools may also vary based on the setup. You will likely need to generate a function-specific file in [servers](servers). 

### General Setup

We first need to start the server with a validation tool.
These setup steps are used regardless of the model. I am doing this in a .devcontainer, and cloning to a temporary spot. Install the fractale library:

```bash
pip install -e .[all] --break-system-packages
git clone -b tweak-flux-operator https://github.com/converged-computing/fractale-agents /tmp/fractale-agents
git clone -b dual-mode https://github.com/converged-computing/mcp-server /tmp/mcpserver
git cloen -b dispath https://github.com/converged-computing/resource-secretary /tmp/rs
pip install -e /tmp/fractale-agents[all] --break-system-packages
pip install -e /tmp/rs[all] --break-system-packages
pip install -e /tmp/mcpserver[all] --break-system-packages
pip install IPython colorama flux-mcp hpc-mcp --break-system-packages
```

### Gemini

This example will show the Flux setup, meaning we have a flux validation tool and run the server alongside a Flux handle. I am using the local [.devcontainer](.devcontainer) to do this. In the container, after [setup](#setup), 
start a flux instance.

```bash
flux start
```

We will need to start the server and add the validation functions and prompt. Start the server with the functions and prompt we need:

```bash
mcpserver start --dual --port 8089
```

In a different terminal, export your API key and the mcp server port.

```bash
export GEMINI_API_KEY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
```

And then run the experiment.

```bash
# Generate the random sample of N=200 (note we did this for jobspec-conversion and are using the same sample)
# python3 scripts/generate-sample.py
flux start
python3 scripts/run-experiment.py --output ./results/base
python3 scripts/run-experiment.py --with-detail --output ./results/details

# Then run for 800 more to get a total of 1k
cp -R ./results/details ./results/1k
python3 scripts/run-experiment.py --with-detail --sample ./sample-1k.json --output ./results/1k
```

Then generate data and results.

```bash
python3 generate_index.py
```

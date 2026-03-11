# Development Setup for OpenAI on Corona

This should set up the development environment and get you up to being able to develop / work on the manager agent using LivAI. Get an allocation:

```bash
flux alloc -N1 --time 24h
```

## 1. Prepare software

These are all development versions of our current libraries, at the branches I am working on. I tried to clone with group permission (and maybe you can use directly) but if not, here is how to create the environment. **Try cd'ing to this location and using my setup before re-doing in case it just works!**

```bash
newgrp fractale
mkdir -p /usr/workspace/fractale/descriptive-thrust/agentic
cd /usr/workspace/fractale/descriptive-thrust/agentic

# This is the agentic orchestrator (generator and runner of plans, etc)
git clone https://github.com/converged-computing/fractale

# This has functions for generic HPC agents (filesystem, containers, etc)
git clone -b update-prompt https://github.com/converged-computing/hpc-mcp

# This of course is for Flux!
git clone https://github.com/converged-computing/flux-mcp
```

Python I'm using (and if you need on your path):

```bash
export PATH=/p/vast1/fractale/descriptive-expression/miniconda3/bin:$PATH
# Flux is here (we likely just need this for server)
export PYTHONPATH=/usr/lib64/python3.12/site-packages
```
```bash
which python
/p/vast1/fractale/descriptive-expression/miniconda3/bin/python
(base) [sochat1@corona211:agentic]$ ls -l $(which python)
lrwxrwxrwx 1 sochat1 fractale 10 May 20  2025 /p/vast1/fractale/descriptive-expression/miniconda3/bin/python -> python3.12
```

Install (and yes I already did to for my Python)!

```bash
pip install -e ./fractale[all]
pip install -e ./flux-mcp
pip install -e ./hpc-mcp
pip install mcp-serve
```

This felt like it took forever... 😩

Clone the experiment directory too.

```bash
git clone --depth 1 https://github.com/converged-computing/fractale-experiments
cd fractale-experiments/jobspec-conversion
```

## 2. MCP Server

Start the mcpserver from an ssh into the same node:

```bash
# This is wherever your job is
ssh corona211
cd /usr/workspace/fractale/descriptive-thrust/agentic/fractale-experiments/jobspec-conversion

# Path stuff again
export PYTHONPATH=/usr/lib64/python3.12/site-packages
export PATH=/p/vast1/fractale/descriptive-expression/miniconda3/bin:$PATH

mcpserver start --port 8089 --host 0.0.0.0 -t http --config ./servers/flux-gemini.yaml 
```
```console
📖 Loading config from ./servers/flux-gemini.yaml
   ✅ Registered: validate_flux_jobspec
   ✅ Registered: validate_jobspec_expert
   ✅ Registered: transform_jobspec_expert
   ✅ Registered: simple_echo
   ✅ Registered: check_finished_prompt
INFO:     Started server process [344968]
INFO:     Waiting for application startup.
INFO:     Application startup complete.
INFO:     Uvicorn running on http://0.0.0.0:8089 (Press CTRL+C to quit)
```

OK nice!

## 3. Fractale

Now let's run fractale with OpenAI. as the agent.  Here are credential stuffs:

```bash
export OPENAI_MODEL=gpt-5.2
export FRACTALE_LLM_PROVIDER=openai
export OPENAI_API_KEY=$(cat /p/vast1/fractale/descriptive-thrust/Src_fractale_de/.livai.tok)
export OPENAI_BASE_URL=https://livai-api.llnl.gov/v1
```

First, I wrote a script to list models.

```bash
python list_models.py
```
```console
Available Models:
[0] gpt-4o-commercial
[1] o1
[2] gpt-4.1-mini
[3] gpt-4o
[4] o3-mini
[5] anthropic.claude-3-5-sonnet-20240620-v1:0
[6] gpt-4.1-nano
[7] gpt-35-turbo
[8] o3
[9] text-embedding-ada-002
[10] gpt-4o-mini
[11] gpt-4.1
[12] o4-mini
[13] claude-haiku-3
[14] claude-sonnet-3.7
[15] gpt-5
[16] gpt-5-mini
[17] gpt-5-nano
[18] gpt-5.1
[19] gpt-5.2
[20] claude-sonnet-4.5
```

### Experiment

Note that these models are not good enough to make plans, but they can call endpoints OK.

```bash
python scripts/run-experiment.py --output ./results/gpt-5.2
export OPENAI_MODEL=claude-sonnet-4.5
python scripts/run-experiment.py --output ./results/claude-sonnet-4.5
```

### Testing

This is how I'm testing directly in IPython

```python
from fractale.engines.native.backends.openai import OpenAIBackend
backend = OpenAIBackend()
```

And I wrote a few scripts to get you started, along with (at least a good start) of the OpenAI backend. A few notes:

- we run the function externally without async
- BUT this API requires async for the model (so hence the backend design)

Try these:

```bash
python test_openai.py
```
```console
(base) [sochat1@corona211:agentic]$ python test_openai.py 

--- Test 1: Tool Selection (flux_resource_list) ---
Response Content: 
Tool Calls Found: [
  {
    "name": "flux_resource_list",
    "args": {
      "uri": null
    }
  }
]
Calls (should not include list_directory): ['flux_resource_list']

--- Test 3: Memory Check ---
Response: Your name is Captain Potato.
b Memory confirmed.
```

Those need more testing for the different modes. You also have these if you need them:

```bash
python list_tools.py 
  Discovered tool: sleep_timer
  Discovered tool: read_file
  Discovered tool: list_directory
  Discovered tool: flux_resource_list
  Discovered tool: flux_validate_jobspec
  Discovered tool: flux_submit_job
  Discovered tool: flux_cancel_job
  Discovered tool: flux_get_job_info
  Discovered tool: flux_get_job_logs
  Discovered tool: flux_sched_qmanager_stats
  Discovered tool: simple_echo
```

And to play with fractale.

```bash
fractale prompt --backend openai List flux resources
```

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
git clone -b dispath https://github.com/converged-computing/resource-secretary /tmp/rs
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
# Generate the random sample of N=200/N=1000 (note we did this for jobspec-conversion and are using the same sample)
# python3 scripts/generate-sample.py
flux start
python3 scripts/run-experiment.py --output ./results/base
python3 scripts/run-experiment.py --with-detail --output ./results/details

# Then run for 800 more to get a total of 1k
cp -R ./results/details ./results/1k
python3 scripts/run-experiment.py --with-detail --sample ./sample-1k.json --output ./results/1k
```

We can calculate the cyclomatic complexity. Since these are akin to bash scripts, we can use [shellmetrics](https://github.com/shellspec/shellmetrics). It's not perfect, but I did a few spot checks and the result was what I'd want or expect - the more complex scripts (with arrays, etc) got a higher score. Since we know our database on LC is now in S3, let's instead write this to an SQL file with a table that can be queried based on path, sha1, or sha256. First, make sure the binary is on your path:

```bash
mkdir -p ./bin
curl -fsSL https://git.io/shellmetrics > ./bin/shellmetrics
chmod +x ./bin/shellmetrics
export PATH=$PWD/bin:$PATH
```

And run for our 1k sample (this defaults to sample-1k.json)

```bash
python scripts/cyclomatic-complexity.py
```

Here is example output, when run manually. Note that I think we want the first section, which has the CCN "cognitive complexity number" for main, which is the main chunk. In the csv, that is the middle block and 4th column "1"

```console
$ shellmetrics data/abdullahrkw/FAU-FAPS/ViT/run-job.sh 
==============================================================================
  LLOC  CCN  Location
------------------------------------------------------------------------------
     5    1  <main> data/abdullahrkw/FAU-FAPS/ViT/run-job.sh
------------------------------------------------------------------------------
 1 file(s), 1 function(s) analyzed. [bash 5.1.16(1)-release]

==============================================================================
 NLOC    NLOC  LLOC    LLOC    CCN Func File (lines:comment:blank)
total     avg total     avg    avg  cnt
------------------------------------------------------------------------------
    5    5.00     5    5.00   1.00    1 data/abdullahrkw/FAU-FAPS/ViT/run-job.sh (20:14:1)
------------------------------------------------------------------------------

==============================================================================
 NLOC    NLOC  LLOC    LLOC    CCN Func File    lines comment   blank
total     avg total     avg    avg  cnt  cnt    total   total   total
------------------------------------------------------------------------------
    5    5.00     5    5.00   1.00    1    1       20      14       1
------------------------------------------------------------------------------
```
```console
$ shellmetrics --csv data/abdullahrkw/FAU-FAPS/ViT/run-job.sh 
file,func,lineno,lloc,ccn,lines,comment,blank
"data/abdullahrkw/FAU-FAPS/ViT/run-job.sh","<begin>",0,0,0,20,14,1
"data/abdullahrkw/FAU-FAPS/ViT/run-job.sh","<main>",0,5,1,0,0,0
"data/abdullahrkw/FAU-FAPS/ViT/run-job.sh","<end>",0,0,0,20,14,1
```

Next, generate a database for files in data.

```bash
python scripts/cyclomatic-complexity.py --input ./data --db ./scripts/data/cyclomatic-complexity-github.db
```



Then generate data and results.

```bash
python3 generate_index.py
```

And then calculate accuracy with the Flux validation with submit and dry run (requires Flux instance running):

```bash
python3 process_metrics.py
```
```console
```

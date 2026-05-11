# Agentic Workflows

We will use the snakemake workflow catalog to select workflows with known wrappers, and then assess the agent's ability to orchestrate without specific instructions.

- total workflows in catalog: 5064 (4/21/2026)
- filtered down to standardized: 425
- and with one or more wrappers: 77

## Graph Generation

We want to be able to give the agent tasks, and then describe them with a prompt, and have the agent repoduce and run with Snakemake wrappers. We first need to understand the ecosystem of the relationships.
We can filter down to the 77 repos above with wrappers. Likely we can filter to all that use wrappers and aren't "standardized" but I want to start with a hardened set.

```bash
pip install pandas seaborn matplotlib snakemake
python generate_graph.py
# web/resources and data
python analyze_software.py
# larger dataset
python analyze_software.py --root ./large-data --outdir ./web/software-large
```

Further analysis, we want to take our data and count extensions, along with adding the snakemake wrappers metadata. Let's parse wrappers first.

```bash
python get_wrappers.py
```

# McpServer Catalogs

This is re-generation of the mcp-server catalog example. We will run this for Snakemake workflows.
The idea of a catalog is a user-specified set of tools that are typically run alongside a job to serve an application. A catalog is a provider that needs to be explicitly added, and then will expose multiple different functions for an agent. Let's first prepare some snakemake data:

```bash
wget https://github.com/snakemake/snakemake-tutorial-data/archive/v5.4.5.tar.gz
tar --wildcards -xf v5.4.5.tar.gz --strip 1 "*/data"
```

Setup your conda:

```bash
conda config --add channels defaults
conda config --add channels bioconda
conda config --add channels conda-forge
conda config --set channel_priority strict
pip install snakemake-wrapper-utils
```

Export envars so the snakemake catalog tools know EXACTLY where the data is (read only) and where to write (should be an empty directory for read/write)

```bash
mkdir -p ./workdir
export RESOURCE_SECRETARY_SNAKEMAKE_WORKDIR=$(pwd)/workdir
export RESOURCE_SECRETARY_SNAKEMAKE_INPUT=$(pwd)/data
```

```bash
mcpserver start --config ./snakemake.yaml --dual --port 8089
```

And now run fractale (and export needed tokens):

```bash
fractale run --database json ./plans/variant-calling.yaml
```

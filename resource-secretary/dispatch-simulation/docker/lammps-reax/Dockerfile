FROM ghcr.io/converged-computing/fractale-agent-experiments:lammps-reax
RUN apt-get update && apt-get install -y \
    build-essential \
    git \
    wget \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /code
RUN pip install mcp-serve flux-mcp[all] fracale[all] hpc-mcp[all] 
RUN git clone -b tweak-flux-operator https://github.com/converged-computing/fractale-agents /code/fractale-agents && python3 -m pip install -e /code/fractale-agents[all]
COPY ./mcpserver.yaml /code/mcpserver.yaml

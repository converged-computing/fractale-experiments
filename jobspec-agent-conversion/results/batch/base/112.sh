#!/bin/bash

#FLUX: --nodes=1
#FLUX: --tasks-per-node=12
#FLUX: -t 24h
#FLUX: --output=$HOME/Projects/FastBGCParameterOptimization/cluster_output/run_TimerOutputs_w0.out
#FLUX: --error=$HOME/Projects/FastBGCParameterOptimization/cluster_output/run_TimerOutputs_w0.out

# NOTE: The PBS directive '-l vmem=94gb' was omitted due to no direct Flux translation.
# This may affect job scheduling; the job might be placed on a node without enough memory.
# NOTE: The PBS directives for email notification ('-M' and '-m') were omitted as there is no Flux equivalent.
# NOTE: The PBS directive '-j oe' was handled by setting the output and error paths to be the same.

# Load the julia module
module load julia/1.1.0

# Go to the root folder on katana
cd $HOME/Projects/FastBGCParameterOptimization

# Set DataDeps environment variable to download without asking
export DATADEPS_ALWAYS_ACCEPT=true

# Run it!
julia src/run_TimerOutputs_w0.jl


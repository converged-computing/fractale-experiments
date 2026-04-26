#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=12
#FLUX: --time-limit=6h
#FLUX: --error=$HOME/Projects/FastBGCParameterOptimization/cluster_output/error.txt
#FLUX: --output=$HOME/Projects/FastBGCParameterOptimization/cluster_output/output.txt

# The PBS parameter for virtual memory (-l vmem) has no direct analog in flux and has been omitted.

# Load the julia module
module load julia/1.1.0

# Go to the root folder on katana
cd $HOME/Projects/FastBGCParameterOptimization

# Set DataDeps environment variable to download without asking
export DATADEPS_ALWAYS_ACCEPT=true

# Run it!
flux mini run -n 12 julia src/run_profile_D2q_method.jl

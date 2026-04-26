#!/bin/bash

# The PBS -l nodes=1:ppn=12 directive is translated to the following:
#FLUX: --nodes=1
#FLUX: --ntasks=12
# The -l vmem=94gb directive has no direct flux analog and is omitted.
#FLUX: --time-limit=24h
# The -j oe, -M, and -m directives are ignored as per instructions or overridden.
#FLUX: --error=$HOME/Projects/FastBGCParameterOptimization/cluster_output/run_TimerOutputs_w0.err
#FLUX: --output=$HOME/Projects/FastBGCParameterOptimization/cluster_output/run_TimerOutputs_w0.out

# Load the julia module
module load julia/1.1.0

# Go to the root folder on katana
cd $HOME/Projects/FastBGCParameterOptimization

# Set DataDeps environment variable to download without asking
# Corrected syntax from '=' to 'export ...=...'
export DATADEPS_ALWAYS_ACCEPT=true

# Run it!
julia src/run_TimerOutputs_w0.jl

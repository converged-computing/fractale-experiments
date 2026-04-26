#!/bin/bash
#FLUX: --job-name=prop_voting_rts_p_sweep
#FLUX: --output=./output/%j.%x.out
#FLUX: --nodes=4
#FLUX: --ntasks-per-node=28
#FLUX: --ntasks=112
#FLUX: --time=20h

# NOTE: The %j and %x format specifiers are not supported in Flux; files will be overwritten.

module load slurm_setup
module load julia/1.8.2

# 'mpiexec' is replaced with 'flux run'
flux run -n 112 julia --project="." -- ./scripts/main.jl ../input/cluster/prop_voting_rts.jl

# The 'sacct' command has no direct equivalent in Flux.
# You can get job information with 'flux job info $FLUX_JOB_ID'

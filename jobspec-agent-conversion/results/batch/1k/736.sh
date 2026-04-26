#!/bin/bash
#FLUX: --ntasks=8
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#FLUX: --output=logs/dsmc_job_%j.out
#FLUX: --error=logs/dsmc_job_%j.err

# NOTE: --open-mode=append is not supported and files will be truncated.
# NOTE: The %j job ID specifier is not supported and filenames will be literal.

# export OMP_PROC_BIND=spread
# export OMP_PLACES=threads
# The SLURM_CPUS_ON_NODE variable is not available in Flux.
# You may need to manually set JULIA_NUM_THREADS. For this job, it would be 8.
# export JULIA_NUM_THREADS=8

echo "running...."

julia RunCells.jl -l 0.001

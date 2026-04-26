#!/bin/bash
#FLUX: --ntasks=24
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#FLUX: --output=logs/dsmc_job_%j.out
#FLUX: --error=logs/dsmc_job_%j.err

# NOTE: --open-mode=append is not supported and files will be truncated.
# NOTE: The %j job ID specifier is not supported and filenames will be literal.

module load intel/19.0.5-fasrc01 openmpi/4.0.2-fasrc01 fftw/3.3.8-fasrc01 cmake/3.12.1-fasrc01 Anaconda3/2019.10 python/3.7.7-fasrc01
module list

export OMP_PROC_BIND=spread
export OMP_PLACES=threads
# The SLURM_CPUS_ON_NODE variable is not available in Flux.
# You may need to manually set JULIA_NUM_THREADS. For this job, it would be 24.
# export JULIA_NUM_THREADS=24

echo "running...."

julia RunCells.jl --T1 2.0000 --T2 2.0000 -l 0.0010 -L 0.0400

#!/bin/bash
#FLUX: --ntasks=16
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#FLUX: --output=logs/dsmc_job.out
#FLUX: --error=logs/dsmc_job.err

# The SLURM directives '--mem-per-cpu' and '--open-mode=append' could not be translated.

module load intel/19.0.5-fasrc01 openmpi/4.0.2-fasrc01 fftw/3.3.8-fasrc01 cmake/3.12.1-fasrc01 Anaconda3/2019.10 python/3.7.7-fasrc01
module list

export OMP_PROC_BIND=spread
export OMP_PLACES=threads
# The $SLURM_CPUS_ON_NODE variable was replaced with the requested core count.
export JULIA_NUM_THREADS=16

echo "running...."

julia RunCells.jl -l 0.002 -L 0.02

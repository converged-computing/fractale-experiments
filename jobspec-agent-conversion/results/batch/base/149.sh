#!/bin/bash
#FLUX: --ntasks=16
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#FLUX: --queue=shared
#FLUX: --output=logs/dsmc_job_{id}.out
#FLUX: --error=logs/dsmc_job_{id}.err

# The SLURM --mem-per-cpu directive has no direct Flux analog in the provided documentation.
# The SLURM --open-mode=append directive has no direct Flux analog.
hostname

module load intel/19.0.5-fasrc01 openmpi/4.0.2-fasrc01 fftw/3.3.8-fasrc01 cmake/3.12.1-fasrc01 Anaconda3/2019.10 python/3.7.7-fasrc01
module list

export OMP_PROC_BIND=spread
export OMP_PLACES=threads
# Replacing $SLURM_CPUS_ON_NODE with $FLUX_JOB_NPROC, which is suitable for a single-node job.
export JULIA_NUM_THREADS=$FLUX_JOB_NPROC

echo "running...."

julia RunCells.jl -l 0.001 -L 0.02

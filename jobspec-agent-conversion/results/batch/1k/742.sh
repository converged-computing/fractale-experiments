#!/bin/bash
#FLUX: --cores=2
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#FLUX: --output=logs/dsmc_job_%J.out
#FLUX: --error=logs/dsmc_job_%J.err

hostname

module load intel/19.0.5-fasrc01 openmpi/4.0.2-fasrc01 fftw/3.3.8-fasrc01 cmake/3.12.1-fasrc01 Anaconda3/2019.10 python/3.7.7-fasrc01
module list
        
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

# In the original script, JULIA_NUM_THREADS was set to $SLURM_CPUS_ON_NODE.
# For a job requesting -N 1 -n 2, this value is 2.
# We set it explicitly to match the number of cores requested.
export JULIA_NUM_THREADS=2
        
echo "running...."
        
julia RunCells.jl --T1 2.0000 --T2 2.8000 -l 0.0025 -L 0.0400 --flow 2.0000

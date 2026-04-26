#!/bin/bash
#FLUX: --cores=24
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#FLUX: --output=logs/dsmc_job_%J.out
#FLUX: --error=logs/dsmc_job_%J.err

hostname
        
module load intel/19.0.5-fasrc01 openmpi/4.0.2-fasrc01 fftw/3.3.8-fasrc01 cmake/3.12.1-fasrc01 Anaconda3/2019.10 python/3.7.7-fasrc01
module list
        
export OMP_PROC_BIND=spread
export OMP_PLACES=threads

# The original script set JULIA_NUM_THREADS to $SLURM_CPUS_ON_NODE, which would be 24.
# We set it explicitly to match the number of cores requested in the Flux jobspec.
export JULIA_NUM_THREADS=24
        
echo "running...."
        
julia RunCells.jl --T1 2.0000 --T2 2.0000 -l 0.0080 -L 0.0200

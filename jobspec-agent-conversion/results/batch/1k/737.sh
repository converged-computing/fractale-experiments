#!/bin/bash
#SBATCH -n 8 # Number of cores requested
#FLUX: --ntasks=8
#FLUX: --nodes=1
#FLUX: --time-limit=8h
#FLUX: --output=logs/dsmc_job_%j.out
#FLUX: --error=logs/dsmc_job_%j.err

# The following Slurm directives could not be translated:
# --mem-per-cpu 2048 (memory request)
# --open-mode=append (file append mode)
# --output and --error filename substitutions (%j)

# module load intel/19.0.5-fasrc01 openmpi/4.0.2-fasrc01 fftw/3.3.8-fasrc01 cmake/3.12.1-fasrc01 Anaconda3/2019.10 python/3.7.7-fasrc01
# module list

# export OMP_PROC_BIND=spread
# export OMP_PLACES=threads
# export JULIA_NUM_THREADS=$SLURM_CPUS_ON_NODE

echo "running...."

julia RunCells.jl -l 0.0005

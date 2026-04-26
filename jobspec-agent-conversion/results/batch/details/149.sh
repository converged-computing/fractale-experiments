#!/bin/bash
# The -n 16 and -N 1 directives are interpreted as a request for 1 task with 16 cores.
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: --time-limit=8h
# The -p shared (partition) directive is ignored as per instructions.
# The --mem-per-cpu 512 directive has no direct flux analog and is omitted.
# The --open-mode=append directive has no direct flux analog and is omitted.
#FLUX: --output=logs/dsmc_job_%j.out
#FLUX: --error=logs/dsmc_job_%j.err

hostname

module load intel/19.0.5-fasrc01 openmpi/4.0.2-fasrc01 fftw/3.3.8-fasrc01 cmake/3.12.1-fasrc01 Anaconda3/2019.10 python/3.7.7-fasrc01
module list

export OMP_PROC_BIND=spread
export OMP_PLACES=threads

# The SLURM_CPUS_ON_NODE variable is replaced with FLUX_JOB_NCORES
export JULIA_NUM_THREADS=$FLUX_JOB_NCORES

echo "running...."

julia RunCells.jl -l 0.001 -L 0.02

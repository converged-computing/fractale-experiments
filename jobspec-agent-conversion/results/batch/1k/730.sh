#!/bin/bash
#FLUX: --job-name=mat_mul
#FLUX: --ntasks=4
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=5m
#FLUX: --output=mat_mul.txt
#FLUX: --error=mat_mul.err

# The --mem-per-cpu slurm parameter has no direct analog in flux submit.
# This may affect job scheduling and performance if the job is memory-intensive.

module load intel
mpicc -n 2  hybrid_mat_mult.c -o hyb -fopenmp 
flux mini run -n 4 ./hyb 4

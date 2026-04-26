#!/bin/bash
#FLUX: --job-name="hpcggpu"
#FLUX: --output="hpcg.%j.%N.out"
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=2
#FLUX: --ntasks=2
#FLUX: --gpus-per-node=2
#FLUX: --time-limit=10m


# NOTE: The %j and %N format specifiers are not supported in Flux; files will be overwritten.

module reset
module load gpu
module load slurm
module load cuda
module load openmpi

# HPCG Problem Size and Running Time is modified in 'hpcg.dat' 

# For Official Runs, Problem Size must occupy at least 1/4 of 
# main memory and Running Time must be at least 1800s 

# --ntasks-per-node, --gpus, and -np should match
# 'mpirun' is replaced with 'flux run'
flux run -n 2 ./xhpcg-3.1_cuda-11_ompi-4.0_sm_60_sm70_sm80 

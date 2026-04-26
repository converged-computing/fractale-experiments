#!/bin/bash
#FLUX: --nodes=32
#FLUX: --ntasks-per-node=32
#FLUX: --cores-per-task=4
#FLUX: --time-limit=30m
#FLUX: --exclusive
#FLUX: --ntasks=1024
 
# Load modules for MPI and other parallel libraries
module load 2021
module load foss/2021a

# 'srun' is replaced with 'flux run' for MPI jobs
flux run -n 1024 julia --project -O3 -t4 drycbl_init.jl --use-mpi --npx 32 --npy 32
flux run -n 1024 julia --project -O3 -t4 drycbl_run.jl --use-mpi --npx 32 --npy 32

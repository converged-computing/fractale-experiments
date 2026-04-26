#!/bin/sh

# Slurm sbatch options
#FLUX: --output=top5norm_forkjoin.log-%j
#FLUX: --ntasks=4

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.


# Initialize Modules
source /etc/profile

# Load Julia and MPI Modules
module load julia-latest
module load mpi/mpich-x86_64

# Call your script as you would from the command line
# 'mpirun' is replaced with 'flux run'
flux run -n 4 julia top5norm_forkjoin.jl

#!/bin/bash

# Flux options
#FLUX: --output=top5norm_collective.log
#FLUX: --ntasks=4

# Initialize Modules
source /etc/profile

# Load Julia and MPI Modules
module load julia
module load mpi

# Call your script as you would from the command line
mpirun julia top5norm_collective.jl

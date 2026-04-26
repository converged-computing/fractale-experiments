#!/bin/bash -l
#FLUX: --job-name=mpi_hello
#FLUX: --output=mpi_hello.out
#FLUX: --error=mpi_hello.err
#FLUX: --time-limit=10m
#FLUX: --ntasks=4
#FLUX: --tasks-per-node=1

PRO=mpi_hello

# Load required software modules
module load gcc/9.3.0-fasrc01 openmpi/4.0.5-fasrc01

# Run program using flux run
flux run ./${PRO}.x > ${PRO}.dat

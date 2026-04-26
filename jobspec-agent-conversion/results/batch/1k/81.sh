#!/bin/bash
#FLUX: --job-name=mpi_bcast
#FLUX: --time-limit=10m
#FLUX: --output=hawk_job.output
#FLUX: --error=hawk_job.output
#FLUX: --requires=rome
#FLUX: --ntasks=8

# change to the directory that the job was submitted from

# load necessary modules
ml r
ml julia

# run program
flux mini run -n 8 julia mpi_bcast_sequential.jl
# mpiexecjl --project -n 8 julia mpi_bcast_tree.jl
# mpiexecjl --project -n 8 julia mpi_bcast_builtin.jl

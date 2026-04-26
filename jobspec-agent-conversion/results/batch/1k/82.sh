#!/bin/bash
#FLUX: --job-name=mpi_bcast
#FLUX: -N 64
#FLUX: --tasks-per-node=1
#FLUX: -t 10m
#FLUX: --output=hawk_job.output
#FLUX: --error=hawk_job.output

# The PBS constraint 'node_type=rome' was omitted as there is no direct generic Flux translation.

# The 'cd "$PBS_O_WORKDIR"' command was removed as Flux jobs typically start in the submission directory by default.

# load necessary modules
ml r
ml julia

# run program using flux's mpi runner
flux mini run -n 64 julia ../mpi_bcast_builtin.jl
flux mini run -n 64 julia ../mpi_bcast_tree.jl
flux mini run -n 64 julia ../mpi_bcast_sequential.jl

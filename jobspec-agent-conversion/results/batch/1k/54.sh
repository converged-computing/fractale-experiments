#!/bin/bash -l

## Flux job-script to run the MPI collective version of darts program.

#FLUX: --job-name=darts-collective
#FLUX: --nodes=1
#FLUX: --time-limit=5m
#FLUX: --ntasks=24
#FLUX: --env=-*

module swap PrgEnv-cray PrgEnv-intel 

flux mini run -n 24 darts-collective

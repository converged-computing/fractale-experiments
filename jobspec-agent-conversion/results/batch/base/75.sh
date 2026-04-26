#!/bin/sh

#FLUX: --queue=gpus
#FLUX: --time-limit=1m
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --error=job.{id}.err
#FLUX: --output=job.{id}.out

# The SLURM --mem directive has no direct Flux analog in the provided documentation.

date

nvidia-smi 

#!/bin/bash
#FLUX: --job-name=pi_monte_carlo
#FLUX: --output=pi_monte_carlo.out
#FLUX: --error=pi_monte_carlo.err
#FLUX: --queue=test
#FLUX: --time-limit=30m
#FLUX: --ntasks=8

# The --mem-per-cpu=4000 parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory (32GB total was requested).

# Load required modules
module load intel/24.0.1-fasrc01 openmpi/5.0.2-fasrc01

# The Slurm srun command has been replaced with the Flux equivalent
flux run -n 8 ./pi_monte_carlo.x

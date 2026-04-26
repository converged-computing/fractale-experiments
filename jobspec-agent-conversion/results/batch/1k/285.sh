#!/bin/bash
#FLUX: --job-name=pi_monte_carlo
#FLUX: --output=pi_monte_carlo.out
#FLUX: --error=pi_monte_carlo.err
# The -p test (partition) directive is ignored as per instructions.
#FLUX: --time-limit=30m
#FLUX: --ntasks=8
# The --mem-per-cpu=4000 directive has no direct flux analog and is omitted.

# Load required modules
module load intel/24.0.1-fasrc01 openmpi/5.0.2-fasrc01

# Run program
# The srun command is replaced by `flux mini run`
flux mini run ./pi_monte_carlo.x

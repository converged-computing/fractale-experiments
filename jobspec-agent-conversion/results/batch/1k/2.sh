#!/bin/bash
#FLUX: --time-limit=1d
#FLUX: --job-name=conv_rand
#FLUX: --error=./conv_pers_rand.err.%j
#FLUX: --output=./conv_pers_rand.out.%j
#FLUX: --ntasks=1
#FLUX: --cores-per-task=24
#FLUX: --exclusive
#FLUX: --nodes=1


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.
# NOTE: The hardware constraint '-C avx' is not supported.

# ----------------------------------

# enable this if running on lichtenberg
module load intel python/3.6.8

### personalised
OMP_NUM_THREADS=20 python3 -u python/analysis/simulations/synth_tests.py 0

OMP_NUM_THREADS=20 python3 -u python/analysis/simulations/synth_tests.py 1

#OMP_NUM_THREADS=20 python3 -u python/analysis/simulations/synth_latent_factor_tests.py



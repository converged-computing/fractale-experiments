#!/bin/bash

#FLUX: --job-name=BBPip
#FLUX: -N 1
#FLUX: -n 1
#FLUX: -c 4
#FLUX: -t 1d
#FLUX: --output=mulitple_jobs_%j.log
#FLUX: --cc=1-300

# The SLURM directive '--mem=20G' was omitted as it has no direct Flux translation.
# The partition directive was ignored as per instructions.
# The filename substitution %j is not supported by Flux and will be treated literally.

# The value for OMP_NUM_THREADS is hardcoded from the --cpus-per-task directive.
export OMP_NUM_THREADS=4

# Replacing mpirun with flux mini run and using the task count from the directives.
flux mini run -n 1 python main.py $1

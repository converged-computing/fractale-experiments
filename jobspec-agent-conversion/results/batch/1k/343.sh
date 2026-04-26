#!/bin/bash
#FLUX: --time-limit=5m
#FLUX: --nodes=1
#FLUX: --job-name=saxpy
#FLUX: --output=saxpy.%J
#FLUX: --error=saxpy.&J


# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.

module load nvhpc/21.9

# jsrun is replaced by 'flux run'. Resource requests are now in the directives.
flux run -n 1 --gpus-per-task=1 --cores-per-task=7 ./saxpy_gpu

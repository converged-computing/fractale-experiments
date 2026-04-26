#!/bin/bash -l
#FLUX: --job-name=CA_EX9_stream
#FLUX: -g 1
#FLUX: -t 2h
#FLUX: -n 1
#FLUX: --output=/home/hpc/rzku/hpcv720h/ex_09/ex09_stream.out
#FLUX: --error=/home/hpc/rzku/hpcv720h/ex_09/ex09_stream.err

# The SLURM directive for a specific GPU model ('--gres=gpu:rtx3080:1') was translated to a generic GPU request.
# The SLURM directive for CPU frequency ('--cpu-freq') was omitted as it has no direct Flux translation.

# Enable debug and verbose mode
set -x
set -v

module load cuda

# 'srun' is not needed for a single-task job in Flux.
../bin/stream_gpu >jacobi_100ms.csv

touch ready

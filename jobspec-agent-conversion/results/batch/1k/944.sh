#!/bin/bash
#FLUX: --job-name=mult_pong
#FLUX: --error=mult_pong.%J.err
#FLUX: --output=mult_pong.%J.out
#FLUX: --nodes=2
#FLUX: --time-limit=15m
#FLUX: --ntasks=2
#FLUX: --cores-per-task=40
#FLUX: --gpus-per-task=4

# The LSF queue directive (-q pdebug) was ignored as per instructions.
# The jsrun command and its arguments were converted to Flux directives.
# The LSF output/error filename substitution (%J) is not supported by Flux.

module load gcc
module load cuda
module load mvapich2

cd /g/g14/bienz1/BenchPress/mvapich_build/examples

nvidia-cuda-mps-control -d

module load valgrind
./time_mult_pong

echo quit | nvidia-cuda-mps-control

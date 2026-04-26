#!/bin/bash
#FLUX: --job-name=all_reduce_std
#FLUX: --error=all_reduce_std.%J.err
#FLUX: --output=all_reduce_std.%J.out
#FLUX: --nodes=2
#FLUX: --time-limit=15m

# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.

module load gcc
module load cmake/3.18.1
module load cuda

cd /ccs/home/bienz/BenchPress/build/examples

# jsrun is replaced by 'flux run'. The complex binding flags are not translated.
# Based on the jsrun flags, we can infer 2 tasks, each with 6 cores and 6 gpus.
flux run -n 2 --cores-per-task=6 --gpus-per-task=6 ./time_collective_standard

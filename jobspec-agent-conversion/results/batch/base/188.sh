#!/bin/bash
#FLUX: --job-name=all_to_all_32
#FLUX: --error=all_to_all_32.{flux:id}.err
#FLUX: --output=all_to_all_32.{flux:id}.out
#FLUX: --nodes=32
#FLUX: -t 15m

# The following directives were derived from the 'jsrun' command in the original script
# There is a conflict in the original script between '-nnodes 32' and jsrun's '-r1' (1 task per node).
# The node count of 32 from the BSUB directive is being used here.
#FLUX: --ntasks=32
#FLUX: --cores-per-task=40
#FLUX: --gpus-per-task=4

# NOTE: The 'jsrun' command and its resource flags have been replaced by 'flux mini run'
#       and corresponding top-level Flux directives.
# NOTE: Several jsrun-specific performance and placement flags have no direct equivalent and were omitted.

module load gcc
module load cuda/10.2.89
module load hwloc

cd /g/g14/bienz1/BenchPress/spectrum_build/examples

nvidia-cuda-mps-control -d

# The jsrun command is replaced by 'flux mini run'
flux mini run -n 32 ./time_alltoall

echo quit | nvidia-cuda-mps-control


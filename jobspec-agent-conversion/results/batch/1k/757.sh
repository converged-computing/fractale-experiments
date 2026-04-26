#!/bin/bash
#FLUX: --job-name=multi-gpu-training
#FLUX: --output=logs/multi-gpu-training_%A_%a.out
#FLUX: --error=logs/multi-gpu-training_%A_%a.err

# The original script contained empty placeholders for partition, node, gpus, and cpus-per-gpu.
# The --mem=1 directive has no direct analog in the provided flux submit options.
# The --output and --error directives do not support Slurm-style job/array ID substitution (%A, %a).

singularity exec --pwd $(pwd) --nv \
  -B /myovision:/mnt \
  image \
  bash -c "cd /mnt/myovision-sam && python3 inference.py"

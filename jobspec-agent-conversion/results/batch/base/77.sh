#!/bin/bash
#
#FLUX: --job-name=JQR
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=12
#FLUX: -t 100h
#FLUX: --gpus-per-node=4

# NOTE: The SLURM directive '--mem=30GB' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

module load python/intel/3.8.6
module load cuda/11.1.74

python3.8 -m torch.distributed.launch --nproc_per_node=4 --master_port 6666 train.py

#!/bin/bash

#FLUX: --job-name=example
#FLUX: -n 1
#FLUX: -c 3
#FLUX: -N 1
#FLUX: -t 2h
#FLUX: -g 1

# The SLURM directive '--mem=60000M' was omitted as it has no direct Flux translation.
# The SLURM partition directive '--partition=gpu_shared_course' was ignored as per instructions.

module purge
module load eb

# Loading modules
module load pre2019
module load Python/3.6.3-foss-2017b
module load cuDNN/7.0.5-CUDA-9.0.176
module load NCCL/2.0.5-CUDA-9.0.176
export LD_LIBRARY_PATH=/hpc/eb/Debian9/cuDNN/7.1-CUDA-8.0.44-GCCcore-5.4.0/lib64:$LD_LIBRARY_PATH

#Copy input data to scratch and create output directorys
# 'srun' is not needed for a single-task job in Flux.
python3 part2/train.py --seq_length 15

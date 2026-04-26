#!/bin/bash
#FLUX: --job-name=q16_uncorr_final
#FLUX: -n 1
#FLUX: -c 3
#FLUX: -N 1
#FLUX: -t 80h
#FLUX: -g 1

# The SLURM directive '--mem=60000M' was omitted as it has no direct Flux translation.
# The SLURM directives for partition and mail were ignored as per instructions.

#module purge

module load pre2019
module load eb
module load Python/3.6.3-foss-2017b
module load cuDNN/7.0.5-CUDA-9.0.176
module load NCCL/2.0.5-CUDA-9.0.176
module load matplotlib/2.1.1-foss-2017b-Python-3.6.3

export LD_LIBRARY_PATH=/hpc/eb/Debian9/cuDNN/7.1-CUDA-8.0.44-GCCcore-5.4.0/lib64:$LD_LIBRARY_PATH

# 'srun' is not needed for a single-task job in Flux.
python3 train_classifier.py

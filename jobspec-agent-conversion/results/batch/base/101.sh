#!/bin/bash
#FLUX: --job-name=federaser
#FLUX: --nodes=1
#FLUX: --output=tensor_out_3.txt
#FLUX: --error=tensor_error_3.txt
#FLUX: --queue=gpu
#FLUX: --gpus-per-node=1

# The --mem=50000 parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.

#module load gnu7/7.2.0
module load cuda/10.0.130
module load anaconda/3.6
#module load mvapich2
#module load pmix/1.2.3

source activate federaser

python ../Fed_Unlearn_main_3.py

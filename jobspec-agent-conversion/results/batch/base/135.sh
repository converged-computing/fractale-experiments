#!/bin/bash

#FLUX: --cores=4
#FLUX: --ntasks=1
#FLUX: --time-limit=6h
#FLUX: --queue=gpu
#FLUX: --gpus-per-task=2
#FLUX: --requires=teslaK80
#FLUX: --output=nv_{id}.out
#FLUX: --error=nv_{id}.err

module load gcc/6.2.0
module load cuda/10.0

echo "#---------"
# This environment variable should be set by Flux when GPUs are allocated.
echo $CUDA_VISIBLE_DEVICES
nvidia-smi
nvidia-smi |grep "|\s*[$CUDA_VISIBLE_DEVICES] "|awk '{print $3}'|xargs -r ps -o pid,ppid,uid -p
echo "#----------"

~/nvida_samples/1_Utilities/deviceQuery/deviceQuery

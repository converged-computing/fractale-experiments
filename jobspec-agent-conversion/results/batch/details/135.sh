#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=6h
# The -p gpu (partition) directive is ignored as per instructions.
# The --gres=gpu:teslaK80:2 directive is translated to a gpu count and a constraint.
#FLUX: --gpus-per-task=2
#FLUX: --requires=teslaK80
#FLUX: --output=nv_%j.out
#FLUX: --error=nv_%j.err

module load gcc/6.2.0
module load cuda/10.0

echo "#---------"
# NOTE: Flux manages GPU visibility automatically through the allocation. 
# The CUDA_VISIBLE_DEVICES variable is set by the environment and does not need to be manually inspected.
echo $CUDA_VISIBLE_DEVICES
nvidia-smi
# The following command is complex and relies on the format of nvidia-smi, which can change.
# It is preserved here but may not be robust.
nvidia-smi |grep "|\s*[$CUDA_VISIBLE_DEVICES] "|awk '{print $3}'|xargs -r ps -o pid,ppid,uid -p
echo "#----------"

~/nvida_samples/1_Utilities/deviceQuery/deviceQuery

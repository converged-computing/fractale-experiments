#!/bin/bash
#FLUX: --nodes=1
#FLUX: --job-name=eval_image_unet_stack_prjs_150k_1x1conv
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --error=eval_image_unet_stack_prjs_150k_1x1conv.err
#FLUX: --output=eval_image_unet_stack_prjs_150k_1x1conv.out
#FLUX: --gpus-per-task=1

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2
module load matlab

python --version
# srun is not required for a single-task job in Flux
python -u eval_unet_invivo_CommQSM.py

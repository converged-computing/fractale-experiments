#!/bin/bash
#FLUX: --nodes=1
#FLUX: --job-name=yang_2L30EPO_pytorch
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --error=ResNet_error.err
#FLUX: --gpus-per-task=2


# NOTE: The specific GPU model request ('tesla-smx2') is not supported.

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2

python --version
# srun is not required for a single-task job in Flux
python -u Train_D_Unet_singleLoss_40EPO.py

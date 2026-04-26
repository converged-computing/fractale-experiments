#!/bin/bash
#FLUX: --nodes=1
#FLUX: --job-name=eval_unrolledTFI
#FLUX: --ntasks=1
#FLUX: --cores-per-task=3
#FLUX: --error=eval_unrolledTFI.err
#FLUX: --output=eval_unrolledTFI.out
#FLUX: --gpus-per-task=1

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2
module load matlab

python --version
python -u eval_QSM.py


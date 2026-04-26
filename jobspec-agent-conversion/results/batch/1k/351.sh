#!/bin/bash
#FLUX: -N 1
#FLUX: --job-name=train_unrolledQSM
#FLUX: -n 1
#FLUX: -c 1
#FLUX: --gpus-per-task=2
#FLUX: -e train_unrolledQSM.err
#FLUX: -o train_unrolledQSM.out

# The slurm memory request (--mem) has no direct analog in flux and has been omitted.
# The slurm request for a specific GPU model (tesla-smx2) is not supported; only the count is used.

module load anaconda/3.6
source activate /opt/ohpc/pub/apps/pytorch_1.10_openmpi
module load cuda/10.0.130
module load gnu/5.4.0
module load mvapich2

flux mini run -n 1 python -u train_QSM.py

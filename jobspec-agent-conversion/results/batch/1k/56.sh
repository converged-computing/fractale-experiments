#!/bin/bash

#FLUX: --job-name=mcquic_pretraining
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-node=1
#FLUX: --requires=a800
#FLUX: --cores-per-task=48
#FLUX: --output=slurm-{id}.out
#FLUX: --error=slurm-{id}.err

# ntask should be equal to N

export HF_ENDPOINT="https://hf-mirror.com"
export PYTHONPATH="/ssdfs/datahome/tj24011/workspace/McQuic"

module load cuda/12.1
source /ssdfs/datahome/tj24011/software/miniconda3/etc/profile.d/conda.sh
conda activate mcquic

TOKENIZERS_PARALLELISM=false NCCL_P2P_LEVEL=NVL OMP_NUM_THREADS=16 torchrun --rdzv-backend=c10d --rdzv-endpoint=localhost:0 --nnodes=1 --nproc_per_node=1 mcquic/train/__main__.py configs/a800_16.yaml

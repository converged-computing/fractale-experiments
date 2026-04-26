#!/bin/bash -l
#FLUX: --output=/jmain02/home/J2AD019/exk01/$USER/logs/{flux:jobid}.out
#FLUX: --job-name=openpsg
#FLUX: --nodes=1
#FLUX: --gpus-per-node=8
#FLUX: --cores-per-task=5
#FLUX: --tasks-per-node=8
#FLUX: -t 1d

# NOTE: The SLURM output path pattern '%u' was replaced with the environment variable '$USER'.
# NOTE: The SLURM output path pattern '%j' was replaced with the Flux pattern '{flux:jobid}'.

source ~/.bashrc
module load cuda
nvidia-smi -i $CUDA_VISIBLE_DEVICES
nvcc --version

CONFIG=$1
GPUS=8
PORT=$(shuf -i 10000-65535 -n 1)

export PYTORCH_CUDA_ALLOC_CONF=max_split_size_mb:128

PYTHONPATH="$(dirname $0)/..":$PYTHONPATH \
EVAL_PAN_RELS=False \
WANDB_MODE="offline" \
python -m torch.distributed.launch \
  --nproc_per_node=$GPUS \
  --master_port=$PORT \
  tools/train.py \
  $CONFIG \
  --auto-resume \
  --no-validate \
  --seed 666 \
  --launcher pytorch


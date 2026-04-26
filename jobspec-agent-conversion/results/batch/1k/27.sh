#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-node=1
#FLUX: --job-name=spbr7
#FLUX: --output=/iliad/u/minae/reward_adaptation/jobs/%x.o

# The --mem=4G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output directive does not support Slurm-style job name substitution (%x).

##CUDA_VISIBLE_DEVICES=0 python train.py --env nav1 --expt_type finetune --bs 7
CUDA_VISIBLE_DEVICES=0 python train.py --env nav1_sparse --bs 7 --experiment_dir output/sparse --expt_type ours
###CUDA_VISIBLE_DEVICES=0 python baselines/PNN/train.py --bs 7
###CUDA_VISIBLE_DEVICES=0 python baselines/L2SP/train.py --bs 5
###CUDA_VISIBLE_DEVICES=0 python baselines/BSS/train.py --bs 7

echo "done"

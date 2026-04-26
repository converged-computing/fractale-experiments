#!/bin/bash -l
#FLUX: --job-name=jupyter_instance
#FLUX: --time-limit=24h
#FLUX: --nodes=1
#FLUX: --cores=8
#FLUX: --gpus-per-node=1
#FLUX: --requires=v100

export PATH=/glade/u/home/gwallach/.conda/envs/goes/bin:$PATH
module load cuda/11 cudnn nccl
python scripts/BinnedCountPredictionModel.py >& countprediction.log

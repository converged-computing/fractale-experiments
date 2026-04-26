#!/bin/bash -l
#FLUX: --job-name=goes16ci
#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=36

export PATH=/glade/u/home/gwallach/.conda/envs/goes/bin:$PATH
module load cuda/11 cudnn nccl
python -u goes16_deep_learning_benchmark.py >& goes_deep_chey.log

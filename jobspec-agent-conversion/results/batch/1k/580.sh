#!/bin/bash
#FLUX: --time-limit=36h
#FLUX: --output=slurm.out
#FLUX: --gpus-per-task=2
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2

module load singularity
singularity exec -B ../SMARTS-lite:/SMARTS-lite --env DISPLAY=$DISPLAY,PYTHONPATH=/SMARTS-lite/ultra:/SMARTS-lite:$PYTHONPATH --home /SMARTS-lite/ultra ../smarts-0416_singularity.sif python ultra/hammer_train.py --task 0-3agents --level easy --policy ppo,ppo,ppo --headless

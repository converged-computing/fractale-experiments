#!/bin/bash
#FLUX: --job-name=molecule
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --time-limit=47h30m
#FLUX: --gpus-per-task=1
#FLUX: --cwd=/scratch/$USER/workspace/MXMNet

source /home01/$USER/.bashrc

module purge
module load singularity/3.9.7
module load htop nvtop
module load gcc/10.2.0
module load cuda/10.2
module list

conda activate mxmnet

echo "START"

python main.py

echo "DONE"


#!/bin/bash
#FLUX: --ntasks=10
#FLUX: --time-limit=2d
#FLUX: --gpus-per-task=1
#FLUX: --output=slurm_%j.out
#FLUX: --error=slurm_%j.err


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.


#Activating conda
source ~/.bashrc
conda activate /scratch/maj596/conda-envs/IPNV2_pytorch

#Your application commands go here
python IPN\ V2_train.py

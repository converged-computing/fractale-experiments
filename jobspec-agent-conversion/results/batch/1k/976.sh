#!/bin/bash
#FLUX: --nodes=1
#FLUX: --job-name=PialNet
#FLUX: --ntasks=1
#FLUX: --cores-per-task=6
#FLUX: --output=out_wiener.txt
#FLUX: --error=error_wiener.txt
#FLUX: --gpus-per-task=1


# NOTE: The specific GPU model request ('tesla-smx2') is not supported.

module load cuda/10.0.130
module load gnu7
module load openmpi3
module load anaconda/3.6
source activate /opt/ohpc/pub/apps/tensorflow_2.0.0

# srun is not required for a single-task job in Flux
python3 vaibhavi/main.py

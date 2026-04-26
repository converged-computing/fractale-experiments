#!/bin/bash
#FLUX: --job-name=HN_15
#FLUX: --ntasks=1
#FLUX: --cores-per-task=6
#FLUX: --gpus-per-task=1
#FLUX: --requires=a40
#FLUX: --time-limit=13h59m
#FLUX: --output=HN_15/slurm.out
#FLUX: --error=HN_15/slurm.err

# The SLURM directive '--mem=20G' could not be translated.

# Environment Setup
module purge
module load python/3.12.0
pip3 install --upgrade pip
pip3 install -U -q pandas numpy tensorflow cuda-python torch torchvision seaborn plotly matplotlib ipywidgets tqdm

# Run Experiments
python3 main.py --data_index 15

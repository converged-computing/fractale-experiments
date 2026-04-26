#!/bin/bash
#FLUX: --job-name=HN_15
#FLUX: -q normal
#FLUX: --cores=6
#FLUX: --gpus-per-node=1
#FLUX: --requires=a40
#FLUX: -t 13h59m
#FLUX: --output=HN_15/slurm-{flux:jobid}.out
#FLUX: --error=HN_15/slurm-{flux:jobid}.err

# NOTE: The Slurm directive '--mem=20G' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

# Environment Setup
module purge
module load python/3.12.0
pip3 install --upgrade pip
pip3 install -U -q pandas numpy tensorflow cuda-python torch torchvision seaborn plotly matplotlib ipywidgets tqdm

# Run Experiments
python3 main.py --data_index 15


#!/bin/bash
#FLUX: --job-name=dask_job
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=7
#FLUX: --time-limit=30h

# Load necessary modules (if required)
# module load your_module
source /home/znazari/.bashrc

# Activate your Python environment
conda activate Zainab-env

# The job will run in the submission directory by default.

# Run your Dask code
python parallel_best_proteomic.py > parallel_result.txt

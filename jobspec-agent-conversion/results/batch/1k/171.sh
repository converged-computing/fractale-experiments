#!/bin/bash
#FLUX: --job-name=load_graphs_batch
#FLUX: --time-limit=2h
#FLUX: --cpus-per-task=4
# The original script's partition was 'gpu', you may need to request a GPU.
# For example: #FLUX: --gpus-per-task=1

# The slurm memory request (--mem) has no direct analog in flux and has been omitted.

# Slurm's dynamic output/error filenames (%x_%j) are not supported in Flux directives.
# We redirect all output for the script using 'exec' and flux environment variables.
mkdir -p ./logs/slurm
exec > ./logs/slurm/${FLUX_JOB_NAME:-load_graphs_batch}_${FLUX_JOB_ID}.out 2> ./logs/slurm/${FLUX_JOB_NAME:-load_graphs_batch}_${FLUX_JOB_ID}.err

module load miniconda
conda activate env_3_8

python load_batch.py

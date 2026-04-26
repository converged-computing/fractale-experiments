#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=6
#FLUX: --time-limit=12h
#FLUX: --gpus-per-node=1
#FLUX: --error="hpc/logs/vis_%A.info"
#FLUX: --output="hpc/logs/vis_%A.info"
#FLUX: --job-name="vis"

# Setup Python Environment
module load Singularity
module load CUDA/10.2.89

# Start singularity instance
singularity exec -H /g/acvt/a1720858/sastvd --nv main.sif python sastvd/linevd/generate_pred_vis.py

#!/bin/bash
#
#FLUX: --time-limit=8h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --output=/scratch/users/dfisher5/slurm-logfiles/slurm-%j.%x.out
#
# --partition=hns,normal means that this will be submitted to both queues, whichever gets to it first will be used.

CONTAINER=ghcr.io/natcap/gcm-downscaling:latest

WORKSPACE_DIR="$L_SCRATCH/$WORKSPACE_NAME"

set -x  # Be eXplicit about what's happening.
FAILED=0
singularity run \
    docker://$CONTAINER python scripts/preprocessing/02_mswep_rechunk_to_zarr.py \
    --n_workers=10 \
    --max_mem=20

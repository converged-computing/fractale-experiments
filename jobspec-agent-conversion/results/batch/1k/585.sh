#!/bin/sh
#FLUX: --job-name=ppoRun
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=10h
#FLUX: --output=logs/%J.out
#FLUX: --error=logs/%J.err

# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.

echo "Running script..."
poetry run python -m ppo --env_name ninja --use_impala --eps 0.4

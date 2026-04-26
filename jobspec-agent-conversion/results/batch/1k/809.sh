#!/bin/bash

#FLUX: --job-name=marl_ippo
#FLUX: --ntasks=32
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --output=slurm_logs/marl_ippo_%j.txt
#FLUX: --error=slurm_errors/marl_ippo_%j.txt

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

current_commit=$(git rev-parse --short HEAD)
project_name="torchrl-example-check-$current_commit"
group_name="mappo_ippo"
export PYTHONPATH=$(dirname $(dirname $PWD))
python $PYTHONPATH/sota-implementations/multiagent/mappo_ippo.py \
  logger.backend=wandb \
  logger.project_name="$project_name" \
  logger.group_name="$group_name"

# Capture the exit status of the Python command
exit_status=$?
# Write the exit status to a file
if [ $exit_status -eq 0 ]; then
  echo "${group_name}_${FLUX_JOB_ID}=success" >> report.log
else
  echo "${group_name}_${FLUX_JOB_ID}=error" >> report.log
fi

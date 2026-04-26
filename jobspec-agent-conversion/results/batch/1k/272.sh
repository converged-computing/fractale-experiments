#!/bin/sh
#FLUX: --job-name=football
#FLUX: -n 1
#FLUX: --cores-per-task=52
#FLUX: -t 2d
#FLUX: --gpus-per-task=1
#FLUX: --output=../results/lumi_output/job_%A_%a.out
#FLUX: --error=../results/lumi_output/array_job_err_%A_%a.txt

# The SLURM directive '--mem=60G' was omitted as it has no direct Flux translation.
# Account and partition directives were ignored as per instructions.
# Filename substitutions %A and %a are not supported by Flux.


flux mini run -n 1 -c 52 singularity run --cleanenv \
--rocm -B /scratch/project_462000215/mappo:/users/wenshuai/projects/mappo \
--env PYTHONPATH=/users/wenshuai/projects/mappo/prj_env/lib/python3.8/site-packages \
/scratch/project_462000215/docker/gfootball_latest.sif \
/bin/sh /users/wenshuai/projects/mappo/scripts/train_football_scripts/train_football_corner.sh


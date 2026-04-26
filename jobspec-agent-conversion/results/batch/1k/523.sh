#!/bin/bash
#FLUX: --time-limit=45m
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --output=resnet30-singularity-bs128_%A_%a.log

# The --mem-per-cpu=8000 directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output directive does not support Slurm-style substitutions (%A, %a).

cd /home/steinba/development/deeprace/
pwd
module load singularity/2.4.2

singularity exec -B $PWD:/home/steinba/deeprace --nv /scratch/steinba/tf1.7-plus.simg python3 /home/steinba/development/deeprace/deeprace.py train -R `mktemp -d` -b tf -O batch_size=128 -c "k80:1,fs:nfs,singularity:lustre" -t /home/steinba/development/deeprace/scripts/tf-short/resnet32v1-tf-short-bs128-singularity-${FLUX_JOB_ID}_${FLUX_JOB_CC}.tsv -e 15 resnet32v1

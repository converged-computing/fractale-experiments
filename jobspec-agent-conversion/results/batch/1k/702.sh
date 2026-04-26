#!/bin/bash
#FLUX: --job-name=slurm-single-job
#FLUX: --output=/nas/volumes/homes/dgx/slurm-single-job.log
#FLUX: -n 1
#FLUX: -g 2

# The SLURM directive '--mem-per-cpu=100' was omitted as it has no direct Flux translation.

# Set Docker Image
export KUBE_IMAGE=registry.local:31500/job-test:latest

# Set your Shared Working Directory
## You're UID/GID must have read/write access to this path
export KUBE_WORK_VOLUME=/nas/volumes/homes/dgx

# Invoke the Job
# 'srun' is not needed for a single-task job in Flux.
../wrappers/kube-slurm-image-job.sh

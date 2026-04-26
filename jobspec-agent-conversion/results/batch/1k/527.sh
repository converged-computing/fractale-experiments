#! /bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=32
#FLUX: --gpus-per-node=4
#FLUX: --job-name=train_primitives_raw_shuffle
#FLUX: --time-limit=6h


set -u
set -e

ulimit -Sn $(ulimit -Hn)

IMAGE=${IMAGE:-/mnt/ceph/users/wzhou/images/gencad.sif}

# NOTE: This script is a job array. The SLURM variables have been replaced
# with Flux variables. You must submit this job with 'flux submit --cc=1-5 ...'
# The output directory structure will differ from the original Slurm job.
OUTPUT_DIR=/mnt/ceph/users/wzhou/projects/gencad/train/primitives_raw_shuffle/${FLUX_JOB_ID}_replicates/$FLUX_JOB_CC

mkdir -p $OUTPUT_DIR

module load singularity
singularity run --cleanenv --containall --nv -B /mnt/ceph/users/wzhou -B $PWD -B $HOME/.ssh --no-home --writable-tmpfs $IMAGE \
    bash -c "cd $PWD && pip install -e . && python -um img2cad.train_primitives_raw +cluster=rusty +compute=4xv100 +ablation=primitives_shuffle batch_size=4096 hydra.run.dir=$OUTPUT_DIR"

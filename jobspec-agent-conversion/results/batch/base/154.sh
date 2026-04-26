#!/bin/bash

# Please adjust these settings according to your needs.
#FLUX: --bank=ece_gy_7123-2024sp
#FLUX: --queue=n1s8-v100-1
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=4h
#FLUX: --job-name=winograd
#FLUX: --output=winograd.out

# The SLURM --mem directive has no direct Flux analog in the provided documentation.
# The SLURM mail directives (--mail-type, --mail-user) have no direct Flux analog.

module purge
cd /home/pa2497/Thai-Winograd
OVERLAY_FILE=/scratch/pa2497/overlay-25GB-500K.ext3:rw
SINGULARITY_IMAGE=/scratch/pa2497/cuda11.4.2-cudnn8.2.4-devel-ubuntu20.04.3.sif
singularity exec --nv \
	    --overlay $OVERLAY_FILE $SINGULARITY_IMAGE \
	    /bin/bash -c "source /ext3/env.sh; bash hpc/run_evaluation.sh"

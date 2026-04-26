#!/bin/bash

# Please adjust these settings according to your needs.
# The --account and --partition directives are ignored as per instructions.
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=4h
# The --mem=25GB directive has no direct flux analog and is omitted.
#FLUX: --gpus-per-task=1
#FLUX: --job-name=winograd
# The --mail-type and --mail-user directives are ignored as per instructions.
#FLUX: --output="winograd.out"


module purge
cd /home/pa2497/Thai-Winograd
OVERLAY_FILE=/scratch/pa2497/overlay-25GB-500K.ext3:rw
SINGULARITY_IMAGE=/scratch/pa2497/cuda11.4.2-cudnn8.2.4-devel-ubuntu20.04.3.sif
singularity exec --nv \
	    --overlay $OVERLAY_FILE $SINGULARITY_IMAGE \
	    /bin/bash -c "source /ext3/env.sh; bash hpc/run_evaluation.sh"

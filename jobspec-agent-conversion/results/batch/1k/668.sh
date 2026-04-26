#!/bin/bash

#FLUX: --job-name=nextsim_small_arctic_10km
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=2h30m
#FLUX: --output=nextsim_small_arctic_10km.out
#FLUX: --error=nextsim_small_arctic_10km.err

source env_dahu.src

CMD="mpirun --allow-run-as-root \
        --mca btl_vader_single_copy_mechanism none \
        --mca btl ^openib \
        --mca pml ob1 \
        -np 4 \
        nextsim.exec --config-files=/config_files/bbm_control.cfg"

/usr/local/bin/singularity exec $NEXTSIM_IMAGE_NAME $CMD


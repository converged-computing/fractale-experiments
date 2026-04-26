#!/bin/bash
#FLUX: --queue=cpulong
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --time-limit=3d
#FLUX: --job-name=sweep
#FLUX: --output=slogs/sweep-{id}.log

# The SLURM --mem-per-cpu directive has no direct Flux analog in the provided documentation.

module purge
singularity exec ${OPENSPIEL_IMG} wandb agent ${WANDB_PROJECT}

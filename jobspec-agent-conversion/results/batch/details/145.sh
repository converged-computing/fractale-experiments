#!/bin/bash
# The --partition cpulong directive is ignored as per instructions.
#FLUX: --nodes=1
#FLUX: --ntasks=1
# The --mem-per-cpu 8G directive has no direct flux analog and is omitted.
#FLUX: --time-limit=3d
#FLUX: --job-name=sweep
#FLUX: --output=slogs/sweep-%J.log

module purge
singularity exec ${OPENSPIEL_IMG} wandb agent ${WANDB_PROJECT}

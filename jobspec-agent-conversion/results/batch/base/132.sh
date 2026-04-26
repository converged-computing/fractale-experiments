#!/bin/bash
#FLUX: -q lowprio
#FLUX: --cores=4
# #FLUX: --gpus-per-node=1

# NOTE: The SLURM directive '--mem=10GB' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

singularity exec --nv ../images/bark_ml.img python3 -u ./configuration

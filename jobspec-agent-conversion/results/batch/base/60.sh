#!/bin/bash
#FLUX: --cores=4
#FLUX: -q mlow
#FLUX: --gpus-per-node=1
#FLUX: --output=logs/{flux:jobname}_{flux:jobid}.out
#FLUX: --error=logs/{flux:jobname}_{flux:jobid}.err

# NOTE: The Slurm directive '--mem 2000' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
# NOTE: The Slurm filename pattern for user name ('%u') was omitted from the output/error files.

python metric_learning.py --arch-type siamese --epochs 200 --process eval

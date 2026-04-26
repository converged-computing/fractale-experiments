#!/bin/bash

#FLUX: --job-name=COLOR
#FLUX: --output=color-3600g.out
#FLUX: --time-limit=10m
#FLUX: --nodes=600

# The following resource requests are derived from the 'jsrun' command:
# -n3600 -> 3600 total tasks
# -r6 -> 6 tasks per node (3600 tasks / 600 nodes)
# -g1 -> 1 GPU per task
# -c1 -> 1 core per task
#FLUX: --ntasks=3600
#FLUX: --tasks-per-node=6
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=1

date

module load gcc cuda 

export LBPM_WIA_DIR=$HOME/summit/build/LBPM-WIA/tests

cd /gpfs/alpinetds/csc275/scratch/mcclurej/SCALING/WEAK/3600p

# The jsrun command has been replaced with flux run. 
# Resource allocation is now handled by the #FLUX directives above.
flux run $LBPM_WIA_DIR/TestCommD3Q19


exit;

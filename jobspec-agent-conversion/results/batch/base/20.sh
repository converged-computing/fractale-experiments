#!/bin/bash
#FLUX: --output=somd-array-gpu-{flux:jobid}.{flux:cc}.out
#FLUX: -q main
#FLUX: --ntasks=1
#FLUX: --gpus-per-node=1
#FLUX: -t 24h

# NOTE: This script is designed as a job array and should be submitted with an option like --cc=RANGE
# For example: flux submit --cc=0-9 this_script.sh

echo "CUDA DEVICES:" $CUDA_VISIBLE_DEVICES

mkdir 10cycles
cd 10cycles

export OPENMM_PLUGIN_DIR=/home/julien/sire.app/lib/plugins/

# srun is not needed for single-task jobs in Flux
~/sire.app/bin/somd-freenrg -C ../sim10.cfg -l 0.50 -p CUDA
cd ..



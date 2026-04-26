#!/bin/bash
#FLUX: --output=somd-array-gpu.out
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=24h

echo "CUDA DEVICES:" $CUDA_VISIBLE_DEVICES

mkdir 10cycles
cd 10cycles

export OPENMM_PLUGIN_DIR=/home/julien/sire.app/lib/plugins/

# The 'srun' command has been replaced with 'flux run'.
flux run ~/sire.app/bin/somd-freenrg -C ../sim10.cfg -l 0.50 -p CUDA
cd ..



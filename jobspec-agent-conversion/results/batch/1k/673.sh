#!/bin/bash
#FLUX: --job-name=InLocCIIRC_demo
#FLUX: --nodes=1
#FLUX: --output=InLocCIIRC_demo.log
#FLUX: --cores-per-task=8
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1d

module load MATLAB/2018a
module load SuiteSparse/5.1.2-foss-2018b-METIS-5.1.0
nvidia-smi
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/lucivpav/gflags-2.2.2/build/lib:/home/lucivpav/InLoc_demo/functions/vlfeat/toolbox/mex/mexa64
cat startup.m inloc_demo.m | matlab -nodesktop

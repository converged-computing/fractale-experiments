#!/bin/sh
#FLUX: --time-limit=2d
#FLUX: --output=out.%J
#FLUX: --ntasks=24
#FLUX: --gpus-per-node=2
#FLUX: --nodes=1



# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.
# NOTE: GPU sharing, exclusive node, and generic resource requests are not supported.

module load cuda90/blas
module load cuda90/fft
module load cuda90/nsight
module load cuda90/profiler
module load cuda90/toolkit
module load cudnn/90v7.0.4

$HOME/build/Python-3.6.7/python $HOME/DnCNN_V1_HPC.py &> output_DnCNN_V1_HPC_1_run11.txt &
wait

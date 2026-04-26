#!/bin/bash -l
#FLUX: --job-name="strong_scaling"
#FLUX: --output=strong_scaling.o
#FLUX: --error=strong_scaling.e
#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --requires=gpu


module load daint-gpu
module load Julia/1.7.2-CrayGNU-21.09-cuda
julia -O3 --check-bounds=no --project=../../.. l8_diffusion_2D_pref_multixpu._SC.jl


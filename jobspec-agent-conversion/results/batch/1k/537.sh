#!/bin/bash

#FLUX: --job-name=" multiGPUproof"
#FLUX: --cwd=.
#FLUX: --output=multiGPU_%j.out
#FLUX: --error=multiGPU_%j.err
#FLUX: --ntasks=1
#FLUX: --cores-per-task=40
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=2m

module purge; module load ffmpeg/4.0.2 gcc/6.4.0 cuda/9.1 cudnn/7.1.3 openmpi/3.0.0 atlas/3.10.3 scalapack/2.0.2 fftw/3.3.7 szip/2.1.1 opencv/3.4.1 python/3.6.5_ML 

#python gradient_descent_modified.py
#python gradient_descent.py
#python singlelayer.py
#python singlelayer_modified.py
#python multilayer.py
python multilayer_modified.py

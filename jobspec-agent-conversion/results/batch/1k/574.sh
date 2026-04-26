#!/bin/bash

#FLUX: --job-name="MAMeEx13"
#FLUX: --cwd=.
#FLUX: --output=/home/nct01/nct01029/AutoLab1/Experiments/13/MAMeEx13_%j.out
#FLUX: --error=/home/nct01/nct01029/AutoLab1/Experiments/13/MAMeEx13_%j.err
#FLUX: --ntasks=1
#FLUX: --cores-per-task=40
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1h

module purge; module load gcc/8.3.0 ffmpeg/4.2.1 cuda/10.2 cudnn/7.6.4 nccl/2.4.8 tensorrt/6.0.1 openmpi/4.0.1 atlas/3.10.3 scalapack/2.0.2 fftw/3.3.8 szip/2.1.1 opencv/4.1.1 python/3.7.4_ML
cd /home/nct01/nct01029/AutoLab1/Experiments/13
python ex13.py

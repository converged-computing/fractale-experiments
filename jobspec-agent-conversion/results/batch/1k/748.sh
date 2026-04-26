#!/bin/bash

##NECESSARY JOB SPECIFICATIONS
#FLUX: --job-name=train
#FLUX: --time-limit=48h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=32
#FLUX: --gpus-per-task=1
#FLUX: --output=./logs/%J.train.log

#First Executable Line
module purge
module load GCC/11.2.0  OpenMPI/4.1.1
# module load TensorFlow/2.7.1-CUDA-11.4.1
module load cuDNN/8.2.2.26-CUDA-11.4.1
ml Anaconda3/2021.05
source activate
conda init bash
conda activate quant
# conda activate $SCRATCH/.conda/envs/quant
nvidia-smi
export LD_LIBRARY_PATH=${CONDA_PREFIX}/lib:${LD_LIBRARY_PATH}
pip --version # check if the correct python version is used

cd ../src; python mt_train.py

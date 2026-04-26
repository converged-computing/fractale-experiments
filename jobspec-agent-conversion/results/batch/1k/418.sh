#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time=4h
#FLUX: --gpus-per-task=1
#FLUX: --job-name=train_lora


module purge
module load python/intel/3.8.6

singularity exec --nv --bind /scratch/yg2709 --overlay /scratch/yg2709/ml_project_env/overlay-25GB-500K.ext3:ro /scratch/yg2709/ml_project_env/cuda11.6.124-cudnn8.4.0.27-devel-ubuntu20.04.4.sif/ /bin/bash -c "

source /ext3/env.sh

pwd

cd /scratch/yg2709/CSCI-SHU-360-Machine-Learning-Final-Project

accelerate launch train_lora_scribble.py

exit
"

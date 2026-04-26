#!  /bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --time-limit=11h30m
#FLUX: --job-name=tensor
#FLUX: --gpus-per-task=1

# The --cluster=htc and --partition=short directives were ignored as per instructions.


module load Anaconda3
module load CUDA/11.8.0
export XLA_FLAGS=--xla_gpu_cuda_data_dir=/apps/system/easybuild/software/CUDA/11.8.0/
source activate /data/math-dewi-nn/ball5622/dewi-tf2-gpu
python run.py


conda deactivate


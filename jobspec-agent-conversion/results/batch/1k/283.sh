#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --output=slurm_logs/%j.out
#FLUX: --error=slurm_logs/%j.err

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

#module load miniconda3
#__conda_setup="$('/dssg/opt/icelake/linux-centos8-icelake/gcc-11.2.0/miniconda3-4.10.3-f5dsmdmzng2ck6a4otduqwosi22kacfl/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
#eval "$__conda_setup"
#conda activate pytorch

# training
python main.py train_evaluate --config_file configs/resnet101_attention.yaml --outputpath experiments/best --schedule_sampling cycle --sample_k 5 --cudaid $1

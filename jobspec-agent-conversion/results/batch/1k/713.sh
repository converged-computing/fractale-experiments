#!/bin/bash
#FLUX: --job-name=my_tensorflow_job
#FLUX: --gpus-per-task=1
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=48h
#FLUX: --output=ADL_output.log
#FLUX: --error=ADL_error.log

# Load required modules or activate the virtual environment
#module load python/3.8.5

source activate tensorflow_env

# Run the TensorFlow jo
python3 -u ex1_main.py --log-interval 1 --seed 42 --epochs 20000 --model "cvit" 


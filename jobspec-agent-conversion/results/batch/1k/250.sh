#!/bin/bash
#FLUX: --job-name=tensorflow
#FLUX: --output=tensorflow.out
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1d

# Load TensorFlow
module purge
module load tensorflow

# Run Python script
python3 example.py


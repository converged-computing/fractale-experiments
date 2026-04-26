#!/bin/sh
#FLUX: --job-name=main
#FLUX: --output=main%J.out
#FLUX: --error=main%J.err
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=2
#FLUX: --time-limit=10h


# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.

# load a scipy module
# replace VERSION and uncomment
module load python3/3.10.7

# load CUDA (for GPU support)
module load cuda/11.7

# activate the virtual environment
# NOTE: needs to have been built with the same SciPy version above!
source torch/bin/activate

python main.py

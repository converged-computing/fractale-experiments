#!/bin/bash
#FLUX: --job-name=WGAN
#FLUX: --output=WGAN.txt
#FLUX: --time-limit=4d
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1

# Read user variables
source $HOME/miniconda3/etc/profile.d/conda.sh
export PATH="$CONDA_ROOT/bin:$PATH"
conda activate WGAN

module load CUDA

# Print some debug information
echo; export; echo; nvidia-smi; echo

$CUDA_ROOT/extras/demo_suite/deviceQuery -noprompt

python run_cwgangp.py

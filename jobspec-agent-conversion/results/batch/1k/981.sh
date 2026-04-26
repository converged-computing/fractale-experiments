#! /bin/bash
#FLUX: --time-limit=48h
#FLUX: --job-name=kgcnn
#FLUX: --nodes=1
#FLUX: --ntasks=16
#FLUX: --gpus-per-node=1
#FLUX: --output=slurm_%j.output

# The --mem=64gb directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output directive does not support Slurm-style job ID substitution (%j).

ulimit -s unlimited

# Load conda and python
eval "$(conda shell.bash hook)"
echo $CONDA_PREFIX

# Choose environment
conda activate leaderboard
echo $CONDA_PREFIX

# Set path to cuda
# Depends on the HPC system.
# If cudatoolkit is installed in conda path:
# export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:$CONDA_PREFIX/lib/
# Cuda from modules if installed by system admin.
# Will be different for different HPCs.
module load devel/cuda/11.8
export LD_LIBRARY_PATH=/opt/bwhpc/common/devel/cuda/11.8/extras/CUPTI/lib64/:$LD_LIBRARY_PATH
export XLA_FLAGS=--xla_gpu_cuda_data_dir=/opt/bwhpc/common/devel/cuda/11.8/
nvidia-smi
echo $LD_LIBRARY_PATH
# For tensorflow >=2.12 require XLA_FLAGS to cuda dir.


# Run python script
python3 run.py

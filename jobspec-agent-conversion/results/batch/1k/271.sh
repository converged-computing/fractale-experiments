#!/bin/bash
#FLUX: --job-name=TEST
#FLUX: --nodes=1
#FLUX: --tasks-per-node=12
#FLUX: --ntasks=12
#FLUX: --cores-per-task=1
#FLUX: --time-limit=20m
#FLUX: --gpus-per-node=1
#FLUX: --output=slurm-report.out
#FLUX: --error=slurm-report.err

# Clean the paths
module purge

# Quantum ESPRESSO - GPU
module load gcc/12
module load FFTW/3.3.10
module load OpenBLAS/0.3.23
module load openmpi-cuda/4.1.5
module load nvhpc/23.3
module load CUDA/12.1

# FLARE - MKL
module load intel/oneapi-2023.1.0
module load compiler/2023.1.0
module load mkl/2023.1.0
source $HOME/flare/bin/activate

# NVIDIA OVERSCRIPTION ACCELERATION
nvidia-cuda-mps-control -d

# As many OMP as SLURM tasks per node
export OMP_NUM_THREADS=12

flare-otf inputs.yaml

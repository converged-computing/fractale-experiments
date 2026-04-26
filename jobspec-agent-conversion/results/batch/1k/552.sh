#!/bin/bash -l

# Copyright 2024 The WarpX Community
#
# Author: Axel Huebl
# License: BSD-3-Clause-LBNL

#FLUX: --time-limit=10m
#FLUX: --nodes=1
#FLUX: --job-name=WarpX
#FLUX: --exclusive
#FLUX: --tasks-per-node=2
#FLUX: --cores-per-task=20
#FLUX: --gpus-per-task=1
#FLUX: --requires=v100
#FLUX: --setopt=cpu-affinity=per-task
#FLUX: --setopt=gpu-affinity=per-task
#FLUX: --output=WarpX.o%j
#FLUX: --error=WarpX.e%j

# The Slurm --gpus-per-task=v100:1 directive was converted to --gpus-per-task=1 and --requires=v100.
# The Slurm --gpu-bind=single:1 and srun --cpu-bind=cores directives are mapped to Flux's cpu-affinity and gpu-affinity options.
# The --output and --error directives do not support Slurm-style job ID substitution (%j).

# executable & inputs file or python interpreter & PICMI script here
EXE=./warpx
INPUTS=inputs

# threads for OpenMP and threaded compressors per MPI rank
export OMP_NUM_THREADS=20

# GPU-aware MPI optimizations
GPU_AWARE_MPI="amrex.use_gpu_aware_mpi=1"

# run WarpX
${EXE} ${INPUTS} ${GPU_AWARE_MPI} > output.txt

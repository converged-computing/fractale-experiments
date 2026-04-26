#!/bin/bash
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --gpus-per-node=4
#FLUX: --cores-per-task=16
#FLUX: --time-limit=12h

# The --mem=1TB directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

# Upload modules
module purge all
module add spack
module add cuda/11.4
module load openmpi/3.1.6-cuda-pmi-ucx-slurm-jhklron

# MPI specific exports
export OMPI_MCA_pml=^ucx
export OMPI_MCA_osc=^ucx
export OMPI_MCA_btl_openib_allow_ib=true

# Julia specific enviromental variables
export COMMON="/nobackup/users/lcbrock/"
export JULIA_DEPOT_PATH="${COMMON}/depot"
export JULIA_CUDA_MEMORY_POOL=none
export JULIA="${COMMON}/julia/julia"

# Profile specific variable
export JULIA_NVTX_CALLBACKS=gc

# Number of threads in SLURM mode
export JULIA_NUM_THREADS=${FLUX_CPUS_PER_TASK:=1}

cat > launch.sh << EoF_s
#! /bin/sh
export CUDA_VISIBLE_DEVICES=0,1,2,3
exec \$*
EoF_s
chmod +x launch.sh

export RX=1
export RY=4

./launch.sh $JULIA --check-bounds=no --project example/run_mpi.jl

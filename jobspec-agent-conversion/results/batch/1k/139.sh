#!/bin/bash
#FLUX: --gpus-per-node=4
#FLUX: --tasks-per-node=4
#FLUX: --ntasks=4
#FLUX: --cores-per-task=4
#FLUX: --nodes=1
#FLUX: --gpu-affinity=per-task


# Initialize Modules
source /usr/share/Modules/init/sh

module load /home/gridsan/groups/llgrid_beta/OpenMPI/3.1.2/openmpi-3.1.2-cuda
module load julia-1.0
module load cuda-latest

export OMPI_MCA_btl=self,tcp

export JULIA_DEPOT_PATH="${HOME}/.julia"
export OPENBLAS_NUM_THREADS=1
flux run -n 4 julia --project=gpuenv -e "using MPI; MPI.Init(); MPI.finalize_atexit(); comm = MPI.COMM_WORLD; @show MPI.Comm_rank(comm); @show MPI.Comm_size(comm); using CUDAdrv; @show length(CUDAdrv.devices())"


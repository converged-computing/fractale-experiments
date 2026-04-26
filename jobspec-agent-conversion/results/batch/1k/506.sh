#!/bin/bash
# Begin LSF Directives
#FLUX: --time-limit=1h30m
#FLUX: --nodes=600
#FLUX: --job-name=mo16x
#FLUX: --output=mo16x.%J
#FLUX: --error=mo16x.%J
	 
# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.

date

export OMP_NUM_THREADS=1
export PAMI_DISABLE_IPC=1
export PAMI_IBV_ENABLE_DCT=1
export PAMI_ENABLE_STRIPING=0
export PAMI_IBV_ADAPTER_AFFINITY=1
export PAMI_IBV_DEVICE_NAME="mlx5_0:1,mlx5_3:1"
export PAMI_IBV_DEVICE_NAME_1="mlx5_3:1,mlx5_0:1"


# NOTE: 'jsrun' and its detailed placement flags have been replaced with 'flux run'.
# Resource allocation is now based on the Flux directives.
# We assume 6 tasks per node (3600 tasks / 600 nodes) and 1 GPU per task.
flux run -n 3600 -N 6 --gpus-per-task=1 --cores-per-task=7 ./dftfe parameterFileGPU.prm > outputGPU600NodesMPS1_mpiopt_mixedprecall_fullscf_ncclallreduce_elpagpu_16blocksize_largerchebyblocksize_nofullsubspacerotmem

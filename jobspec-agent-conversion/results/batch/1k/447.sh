#!/bin/bash

#FLUX: --job-name=spy_heat
#FLUX: --output=slurm.%N.%j.out
#FLUX: --error=slurm.%N.%j.err
#FLUX: --nodes=2
#FLUX: --time=10m

# NOTE: The %N and %j format specifiers are not supported in Flux; files will be overwritten.


module load anaconda/3/2021.11
conda activate heat

#module load gcc/12
module load openmpi/4
module load netcdf-mpi/4.8.1
module load mpi4py/3.0.3
module load gpytorch/gpu-cuda-11.2/pytorch-1.9.0/1.5.1

SPYTMPDIR=/ptmp ~/develop/playground/heat_cluster/syncopy_heat_script.py

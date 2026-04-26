#!/bin/sh
#FLUX: --time-limit=30m
#FLUX: --nodes=1
#FLUX: --ntasks=1


module load openmpi/4.1.4
module load CUDA/11.7
module load lammps/2022sep15_cpu

# The srun command has been replaced with the standard Flux launcher 'flux mini run'.
flux mini run -n 1 lmp -i in.eam

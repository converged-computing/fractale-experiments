#!/bin/bash -l

#FLUX: --job-name=MURbui
#FLUX: -B UCSU0085
#FLUX: -q main@gusched01
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-node=1
# #FLUX: --requires=a100
#FLUX: -t 10m
#FLUX: --error=build.err
#FLUX: --output=build.out

# NOTE: The PBS directive '-l mem=50GB' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
# NOTE: The PBS account directive '-A' has been mapped to the Flux bank directive '-B'.

module purge
module load ncarenv/22.12
module load nvhpc/22.11
module load cuda
module load craype
module load cray-mpich
module load ncarcompilers
module load cray-libsci
module list

make clean
make

 


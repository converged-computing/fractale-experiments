#!/bin/bash
#FLUX: --job-name=stream4
#FLUX: --nodes=4
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=16
#FLUX: --time-limit=5m
#FLUX: --output=new_mpi_build/mpistream4.out

module load compilers/armclang/24.04
module load libraries/openmpi/5.0.3/armclang-24.04

export OMP_NUM_THREADS=16

# All nodes, all cores
flux run -n 4 ./STREAM/mpi_stream

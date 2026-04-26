#!/bin/bash
#FLUX: --nodes=2
#FLUX: --ntasks=16

NPROCS=16
source ~/init.sh
make clean && make
rm -r hpctoolkit*

# The -npersocket option from mpirun has no direct analog in flux run.
# Flux may provide other mechanisms for affinity control, such as
# task mapping options, but they are not a direct translation.
flux run -n $NPROCS hpcrun -e CPUTIME -e IO -e gpu=nvidia -t ./jacobi

hpcstruct --gpucfg yes hpctoolkit*
hpcstruct --gpucfg yes jacobi
hpcprof -S jacobi.hpcstruct -I jacobi.cpp -I jacobi_kernels.cu -I ./+ hpctoolkit*
echo "===DONE==="

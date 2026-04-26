#!/bin/bash
#FLUX: --nodes=2

# NOTE: The MPI launch command has been updated to use 'flux mini run'.
# The original script's process placement option '-npersocket' has no direct equivalent
# and is now handled by Flux's default task mapper.

NPROCS=16
NPPERSOC=$(($NPROCS>>2))
source ~/init.sh
make clean && make
rm -r hpctoolkit*

# The original script used 'mpirun'. The idiomatic way to run this in Flux
# is with 'flux mini run', which uses the allocated resources automatically.
flux mini run -n $NPROCS hpcrun -e CPUTIME -e IO -e gpu=nvidia -t ./jacobi

hpcstruct --gpucfg yes hpctoolkit*
hpcstruct --gpucfg yes jacobi
hpcprof -S jacobi.hpcstruct -I jacobi.cpp -I jacobi_kernels.cu -I ./+ hpctoolkit*
echo "===DONE==="

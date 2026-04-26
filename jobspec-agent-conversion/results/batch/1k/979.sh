#!/bin/bash
#FLUX: --nodes=2
#FLUX: --ntasks=16

NPROCS=16
NPPERSOC=$(($NPROCS>>2))
echo $NPROCS $NPPERSOC
source ~/init.sh
make clean && make
flux run -n $NPROCS hpcrun -e CPUTIME -e IO -e gpu=nvidia -t ./jacobi
hpcstruct --gpucfg yes hpctoolkit*
hpcstruct --gpucfg yes jacobi
hpcprof -S jacobi.hpcstruct -I jacobi.cpp -I jacobi_kernels.cu -I ./+ hpctoolkit*
zip -r result.zip hpctoolkit-jacobi-database-*
echo "===DONE==="


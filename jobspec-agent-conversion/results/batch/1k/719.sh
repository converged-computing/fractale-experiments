#!/bin/bash
#FLUX: --job-name=IS
#FLUX: --ntasks=64
#FLUX: --nodes=1
#FLUX: --output=abacus.log
#FLUX: --error=abacus.err

module load abacus/3.4.1-icc

# OMP abacus have better performace than MPI - 2023.9.1
export OMP_NUM_THREADS=4
NP=$(expr $FLUX_NTASKS / $OMP_NUM_THREADS)

# doing job
touch JobProcessing.state
echo `date` >> JobProcessing.state 

flux run -n $NP abacus

echo `date` >> $HOME/finish
echo `pwd` >> $HOME/finish
echo `date` >> JobProcessing.state


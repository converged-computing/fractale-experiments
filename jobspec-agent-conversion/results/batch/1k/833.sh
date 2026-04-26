#!/bin/bash
#FLUX: --job-name=VB_nmRec
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --cores-per-task=8
#FLUX: --time-limit=10m
#FLUX: --gpus-per-task=1

# The account, partition, and qos directives were ignored as per instructions.

module load profile/lifesc
module unload fftw
module load gromacs/2021.7--openmpi--4.1.4--gcc--11.3.0-cuda-11.8

export OMP_NUM_THREADS=8

echo -n "Starting Script at: "
date

wait
gmx_mpi mdrun -s md_Meta.tpr -plumed VB_MetaD.dat -ntomp 8 -v -nb gpu -pme auto -pin off

wait
echo ""
echo "Finished first benchmark for VB meta!!"
echo ""

echo "done at"
date

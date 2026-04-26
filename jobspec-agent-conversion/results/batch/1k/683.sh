#!/bin/bash
#FLUX: --job-name=Ar
#FLUX: --output=Ar.o%j
#FLUX: --error=Ar.e%j
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=40
#FLUX: --ntasks=40
#FLUX: --time-limit=1h
#FLUX: --exclusive

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

ulimit -s unlimited
export OMP_NUM_THREADS=1
echo "FLUX_NTASKS: " 40

module purge
module load intel/2021.2
module load impi/2021.2
module load contrib
module load lammps-msel/29Sep2021

date 
echo "My LAMMPS Simulation"
# 'srun' is replaced with 'flux run'
flux run -n 40 lmp -in in.lammps
date

#!/bin/bash
#FLUX: --job-name=run-equilibration
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --cores-per-task=1
#FLUX: --time-limit=4h

source /scratch/work/courses/CHEM-GA-2671-2022fa/software/lammps-gcc-30Oct2022/setup_lammps.bash

mpirun lmp -var configfile ../Inputs/n360/kalj_n360_create.lmp -var id 1 -in ../Inputs/create_3d_binary.lmp

for i in 1.5 1.0 0.9 0.8 0.7 0.65 0.6 0.55 0.5 0.475
do
    mpirun lmp -var configfile ../Inputs/n360/kalj_n360_T$i.lmp -var id 1 -in ../Inputs/anneal_3d_binary.lmp
done

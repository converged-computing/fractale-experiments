#!/bin/bash
#FLUX: --job-name=lmp_test
#FLUX: --nodes=4
#FLUX: --tasks-per-node=2
#FLUX: --cores-per-task=4
#FLUX: --ntasks=8
#FLUX: --time-limit=1h
#FLUX: --output=pbs.log
#FLUX: --cwd=.

echo "nodefile: $PBS_NODEFILE"

module load lammps/23Jun2022_update1-b1
# openmpi/4.1.2-hpe
module load openmpi

input_file=new.lmp
# mpirun -n 8 lmp -in ${input_file} 1>  ${input_file%.lmp}.log 2> error.log
flux run -n 8 lmp -in ${input_file} 1>  ${input_file%.lmp}.log 2> error.log

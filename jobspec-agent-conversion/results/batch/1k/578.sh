#!/bin/sh

#FLUX: --tasks-per-node=40
#FLUX: --nodes=1
#FLUX: --ntasks=40

module load lammps/2020/intel

# mpiexec is replaced by 'flux run'. The number of tasks is taken from the job spec.
flux run -n 40 lmp -in dpd_water_100x100x100_t1000.txt

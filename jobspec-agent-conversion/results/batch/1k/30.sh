#!/bin/sh
# Job name:
#FLUX: --job-name=filip80-0
#
# Project:
#
# Wall clock limit:
#FLUX: --time-limit=10h
#
# Max memory usage per task:
#
# Number of tasks (MPI ranks):
#FLUX: --nodes=4
#FLUX: --tasks-per-node=16
#FLUX: --ntasks=64

## Set up job environment
source /cluster/bin/jobsetup
module load intel
module load intelmpi.intel
module load python2

## Run command
flux run -n 64 /work/users/henriasv/filip/lammps/src/lmp_intel_cpu_intelmpi -in inputScripts/system.run.80000v50


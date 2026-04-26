#!/bin/sh 
#FLUX: --nodes=8
#FLUX: --tasks-per-node=24
#FLUX: --job-name=testjob

# Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is omitted.
ulimit -s unlimited

# The number of processors is determined by the Flux allocation, which is 8 nodes * 24 tasks/node = 192 tasks.
NPROCS=192

date > testjob.dat
hostname >> testjob.dat
pwd >> testjob.dat

echo 'FLUX_JOB_ID: '$FLUX_JOB_ID >> testjob.dat
echo 'Total tasks: '$NPROCS >> testjob.dat

# The MPI launch command has been updated to use the Flux native launcher.
flux mini run -n 192 /home/shimizu/lammps-12Dec18/build-hara/lmp -partition 8x24 -in in.neb >> testjob.dat

#!/bin/bash

#Submit this script with: sbatch thefilename

#FLUX: --time-limit=1h
#FLUX: --ntasks=16
#FLUX: --job-name="add"


SCOREP_ENABLE_PROFILING=true
SCOREP_ENABLE_TRACING=false
# Set the max number of threads to use for programs using OpenMP. Should be <= ppn. Does nothing if the program doesn't use OpenMP.
# The SLURM_CPUS_ON_NODE variable is not available in Flux.
# You may need to manually set OMP_NUM_THREADS.
# export OMP_NUM_THREADS=$SLURM_CPUS_ON_NODE
#OUTFILE="out.txt"
psc_frontend --apprun=../add.exe --mpinumprocs=1 --tune=mpicap --phase="mainRegion" --force-localhost
#psc_frontend --apprun=../add.gdb --mpinumprocs=1 --tune=mpicap --phase="mainRegion" --force-localhost
#psc_frontend --apprun=../add.valgrind --mpinumprocs=1 --tune=mpicap --phase="mainRegion" --force-localhost

exit 0

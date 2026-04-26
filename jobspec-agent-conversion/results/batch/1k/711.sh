#!/bin/bash
#FLUX: --job-name=hello-mpi
#FLUX: --cores-per-task=1
#FLUX: --ntasks=4
#FLUX: --nodes=1
#FLUX: --exclusive
#FLUX: --time-limit=9s

#mpiexec  -np 2 ./hello_world
#export I_MPI_PMI_LIBRARY=/cm/shared/apps/slurm/current/lib64/libpmi2.so

flux resource list -o hosts

sleep 10 
flux run -n $FLUX_NTASKS ./hello_world



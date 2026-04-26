#!/bin/bash
#FLUX: --nodes=4
#FLUX: --ntasks-per-node=20
#FLUX: --ntasks=80
#FLUX: --time=10h
#FLUX: --output=cluster.out
#FLUX: --error=cluster.err
#FLUX: --job-name=Pump


export KMP_AFFINITY=compact,1,0

module load compiler/intel/19.1
module load mpi/openmpi/4.0

# Attention:
# Do NOT add mpirun options -n <number_of_processes> or any other option defining processes or nodes, since MOAB instructs mpirun about number of processes and node hostnames. Moreover, replace <placeholder_for_version> with the wished version of Intel MPI to enable the MPI environment. 

# 'mpirun' is replaced with 'flux run'
flux run -n 80 lmp_mpi -in $(pwd)/load.LAMMPS

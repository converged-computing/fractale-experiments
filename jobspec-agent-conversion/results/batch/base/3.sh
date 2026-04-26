#!/bin/bash
#FLUX: --bank=*FIXME*
#Asking for 40 min.
#FLUX: --time-limit=40m
#Number of nodes
#FLUX: --nodes=1
#Ask for processes
#FLUX: --ntasks=28
#FLUX: --gpus-per-node=2
#FLUX: --requires=k80
#FLUX: --exclusive

ml purge > /dev/null 2>&1
ml GCC/9.3.0  CUDA/11.0.2  OpenMPI/4.0.3
ml NAMD/2.14-nompi 
namd2 +p28 abf.inp > output_abf.dat

#MPI version
#ml GCC/10.3.0  OpenMPI/4.1.1
#ml NAMD/2.14-mpi 
#mpirun -np 28 namd2 abf.inp > output_abf.dat

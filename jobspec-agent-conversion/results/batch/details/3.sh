#!/bin/bash
# The -A *FIXME* (account) directive is a placeholder and is ignored.
#FLUX: --time-limit=40m
#FLUX: --nodes=1
# The -n 28 is interpreted as cores-per-task for this non-MPI application.
#FLUX: --ntasks=1
#FLUX: --cores-per-task=28
# The --gres=gpu:k80:2 directive is translated to a gpu count and a constraint.
#FLUX: --gpus-per-task=2
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

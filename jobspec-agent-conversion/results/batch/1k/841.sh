#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=16
#FLUX: --job-name=Venzke
#FLUX: --cwd=.

TDSE_ROOT=$HOME/Repos/TDSE

RUN_FILE=${TDSE_ROOT}/bin/TDSE
#RUN_FILE=./TDSE

module purge 
module load intel 
module load openmpi
module load hdf5 
module load boost
module load cmake
module load blas
module list


pwd 
export TMPDIR=/scratch/becker/jove7731
echo $TMPDIR
echo ${RUN_FILE}
flux run -n 16 ${RUN_FILE}  -eigen_ksp_type preonly -eigen_pc_type lu -eigen_pc_factor_mat_solver_package superlu_dist > run.log


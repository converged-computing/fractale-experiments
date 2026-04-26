#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores=24
#FLUX: --ntasks=6
#FLUX: --time-limit=5m
#FLUX: --job-name=md_24_6
#FLUX: --output=md_24_6_out
#FLUX: --error=md_24_6_err
  

module load gcc91
module load openmpi-3.0.0
module load BLAS
module load gsl-2.5
module load lapack-3.7.0
  
module load cuda-11.3

# Flux jobs are typically started in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/giuseppe.gambini/usr/installations/plumed/lib
source /home/giuseppe.gambini/usr/src/gmx_plumed.sh

# OMP_NUM_THREADS=4 is consistent with the resource request of 24 cores for 6 tasks (4 cores/task).
export OMP_NUM_THREADS=4

# The direct 'mpirun' call has been replaced with the idiomatic Flux launcher 'flux mini run'.
flux mini run -n 6 /home/giuseppe.gambini/usr/installations/gromacs/bin/gmx_mpi mdrun -s ../../md_meta.tpr -plumed meta.dat

#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --cores-per-task=16
#FLUX: --time-limit=5m
#FLUX: --job-name=md_64_4
#FLUX: --output=md_64_4_out
#FLUX: --error=md_64_4_err
  

module load gcc91
module load openmpi-3.0.0
module load BLAS
module load gsl-2.5
module load lapack-3.7.0
  
module load cuda-11.3

# The 'cd $PBS_O_WORKDIR' command was removed as Flux jobs typically
# start in the directory from which they are submitted.
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/giuseppe.gambini/usr/installations/plumed/lib
source /home/giuseppe.gambini/usr/src/gmx_plumed.sh

export OMP_NUM_THREADS=16

# The 'mpirun' command has been replaced with 'flux run'.
flux run -n 4 /home/giuseppe.gambini/usr/installations/gromacs/bin/gmx_mpi mdrun -s ../../md.tpr

#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1h
#FLUX: --job-name=md_6
#FLUX: --output=md_6_out
#FLUX: --error=md_6_err

  

module load gcc91
module load openmpi-3.0.0
module load BLAS
module load gsl-2.5
module load lapack-3.7.0
  
module load cuda-11.3

# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/giuseppe.gambini/usr/installations/plumed/lib
source /home/giuseppe.gambini/usr/src/gmx_plumed.sh

export OMP_NUM_THREADS=1

# 'mpirun' is replaced with 'flux run'
flux run -n 1 /home/giuseppe.gambini/usr/installations/gromacs/bin/gmx_mpi mdrun -s md_6.tpr -nb gpu -pme auto

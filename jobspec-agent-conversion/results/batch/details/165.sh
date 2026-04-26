#!/bin/bash
# The -q short_cpuQ directive is ignored as per instructions.
# The PBS select statement is translated to the following flux directives, assuming a hybrid MPI+OpenMP model based on the script's content (mpiprocs=4, OMP_NUM_THREADS=5).
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --cores-per-task=5
# The mem=1GB directive has no direct flux analog and is omitted.
#FLUX: --time-limit=5m
#FLUX: --job-name=md_20_4
#FLUX: --output=md_20_4_out
#FLUX: --error=md_20_4_err
  

module load gcc91
module load openmpi-3.0.0
module load BLAS
module load gsl-2.5
module load lapack-3.7.0
  
module load cuda-11.3

# The PBS_O_WORKDIR variable is replaced by FLUX_JOB_CWD
cd $FLUX_JOB_CWD

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/giuseppe.gambini/usr/installations/plumed/lib
source /home/giuseppe.gambini/usr/src/gmx_plumed.sh

export OMP_NUM_THREADS=5
  
# The mpirun command is replaced with `flux mini run`. The -np flag is not needed.
/apps/openmpi-3.0.0/bin/mpirun -np 4 /home/giuseppe.gambini/usr/installations/gromacs/bin/gmx_mpi mdrun -s ../../md_meta.tpr -plumed meta.dat

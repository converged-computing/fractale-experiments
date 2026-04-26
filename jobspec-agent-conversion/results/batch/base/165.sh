#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --cores-per-task=5
#FLUX: --time-limit=5m
#FLUX: --queue=short_cpuQ
#FLUX: --job-name=md_20_4
#FLUX: --output=md_20_4_out
#FLUX: --error=md_20_4_err

# The PBS parameter 'mem=1GB' has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.


module load gcc91
module load openmpi-3.0.0
module load BLAS
module load gsl-2.5
module load lapack-3.7.0
  
module load cuda-11.3

# The cd $PBS_O_WORKDIR command is not needed as Flux jobs start in the submission directory by default
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/giuseppe.gambini/usr/installations/plumed/lib
source /home/giuseppe.gambini/usr/src/gmx_plumed.sh

export OMP_NUM_THREADS=5
  
# The mpirun command has been replaced with flux run.
# Flux will launch 4 tasks as specified by the --ntasks directive.
flux run /home/giuseppe.gambini/usr/installations/gromacs/bin/gmx_mpi mdrun -s ../../md_meta.tpr -plumed meta.dat

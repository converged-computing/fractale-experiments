#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=24
#FLUX: --time-limit=5m
#FLUX: --job-name=md_24_24
#FLUX: --output=md_24_24_out
#FLUX: --error=md_24_24_err

# The PBS memory request (-l mem=1GB) has no direct analog in the provided flux submit options.
# The -q (queue) directive was ignored as per instructions.
# The cd to $PBS_O_WORKDIR was removed as Flux starts in the submission directory by default.

module load gcc91
module load openmpi-3.0.0
module load BLAS
module load gsl-2.5
module load lapack-3.7.0

module load cuda-11.3

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/giuseppe.gambini/usr/installations/plumed/lib
source /home/giuseppe.gambini/usr/src/gmx_plumed.sh

export OMP_NUM_THREADS=1

/home/giuseppe.gambini/usr/installations/gromacs/bin/gmx_mpi mdrun -s ../../md_meta.tpr -plumed meta.dat

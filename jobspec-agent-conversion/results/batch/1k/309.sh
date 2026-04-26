#!/bin/bash 
#FLUX: --job-name=run-gromacs
#FLUX: --nodes=1
#FLUX: --ntasks=4
# The --mem=8GB directive has no direct flux analog and is omitted.
#FLUX: --time-limit=24h

module purge
module load gromacs/openmpi/intel/2020.4

# The mpirun command is replaced by `flux mini run`
flux mini run -n 1 gmx_mpi mdrun -deffnm md_50

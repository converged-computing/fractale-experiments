#!/bin/bash 
#FLUX: --job-name=run-gromacs
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --time-limit=24h

# The SLURM --mem directive has no direct Flux analog in the provided documentation.

module purge
module load gromacs/openmpi/intel/2020.4

# The mpirun command is replaced by flux mini run.
# The number of processes (-n 1) is preserved from the original mpirun command.
flux mini run -n 1 gmx_mpi mdrun -deffnm md_50

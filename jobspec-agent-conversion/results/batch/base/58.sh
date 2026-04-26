#!/bin/bash 
#FLUX: --job-name=EQ_POCG_60
#FLUX: --queue=cmain
#FLUX: --nodes=3
#FLUX: --ntasks=96
#FLUX: --time-limit=30m
#FLUX: --output=starting.out

# The --mem=6000 parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.
# The --requeue parameter from slurm has no direct equivalent in flux-submit.
# The --export=ALL parameter is default behavior in Flux and is not needed.

module purge
module load gcc cuda mvapich2/2.2
NAMD="/projects/jdb252_1/tj227/bin/namd2-2.13-gcc-mvapich2"

# The SLURM srun command has been replaced with flux run
flux run $NAMD starting.POCG_60.namd > starting.POCG_60.log

#!/bin/bash 
#FLUX: --job-name=EQ_POEG_19
#FLUX: --nodes=3
#FLUX: --ntasks=96
#FLUX: --time-limit=3h
#FLUX: --output=starting.out

module purge
module load gcc cuda mvapich2/2.2
NAMD="/projects/jdb252_1/tj227/bin/namd2-2.13-gcc-mvapich2"

# The original 'srun' command has been replaced with the standard Flux launcher 'flux mini run'.
flux mini run -n 96 $NAMD starting.POEG_19.namd > starting.POEG_19.log

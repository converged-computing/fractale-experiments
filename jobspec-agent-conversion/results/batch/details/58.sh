#!/bin/bash 
#FLUX: --job-name=EQ_POCG_60
# The -o out%j.amarel.log directive is overridden by the later --output directive.
# The --export=ALL directive is the default behavior in flux and is omitted.
# The --partition=cmain directive is ignored as per instructions.
#FLUX: --nodes=3
#FLUX: --ntasks=96
# The --mem=6000 directive has no direct flux analog and is omitted.
#FLUX: --time-limit=30m
#FLUX: --output=starting.out
# The --requeue directive has no direct flux analog and is omitted.

module purge
module load gcc cuda mvapich2/2.2

NAMD="/projects/jdb252_1/tj227/bin/namd2-2.13-gcc-mvapich2"

# The Slurm srun command is replaced with flux mini run
flux mini run $NAMD starting.POCG_60.namd > starting.POCG_60.log

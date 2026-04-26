#!/bin/bash
# The first line of the original script was malformed and interpreted as two directives.
#FLUX: --job-name=1687
#FLUX: --output=out_%j.log
#FLUX: --error=err_%j.log
#FLUX: --ntasks=16
#FLUX: --tasks-per-node=16
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=6h

# The --mem-per-cpu=1000mb directive has no direct analog in the provided flux submit options.
# The --ntasks-per-socket=16 directive has no direct analog in the provided flux submit options.
# The --output and --error directives do not support Slurm-style job ID substitution (%j).

module purge
module load intel/2019.1.144
module load openmpi/4.0.1

/home/joshuapaul/vasp_10-23-19_5.4.4/bin/vasp_stand > job.log
echo Done

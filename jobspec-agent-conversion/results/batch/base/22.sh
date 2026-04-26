#!/bin/bash
#FLUX: --job-name=2440
#FLUX: --output=out_{id}.log
#FLUX: --error=err_{id}.log
#FLUX: --nodes=1
#FLUX: --ntasks=16
#FLUX: --tasks-per-node=16
#FLUX: --cores-per-task=1
#FLUX: --time-limit=6h

# The SLURM --qos directive has no direct Flux analog. The --queue option might be a replacement.
# The SLURM --ntasks-per-socket directive has no direct Flux analog.
# The SLURM --mem-per-cpu directive has no direct Flux analog in the provided documentation.

# Flux jobs start in the submission directory by default.

module purge
module load intel/2019.1.144
module load openmpi/4.0.1

flux mini run /home/joshuapaul/vasp_10-23-19_5.4.4/bin/vasp_stand > job.log
echo Done

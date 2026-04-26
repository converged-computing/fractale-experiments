#!/bin/bash
#FLUX: --job-name=2120
#FLUX: --output=out_{id}.log
#FLUX: --error=err_{id}.log
#FLUX: --ntasks=16
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=6h

# The --qos=hennig parameter from slurm has no direct equivalent in flux-submit.
# The --ntasks-per-socket=16 parameter from slurm has no direct equivalent in flux-submit.
# The --mem-per-cpu=1000mb parameter (16GB total) has no direct equivalent in flux-submit.
# The job may fail due to insufficient memory.

# The 'cd $SLURM_SUBMIT_DIR' command is not needed as Flux jobs start in the submission directory by default.

module purge
module load intel/2019.1.144
module load openmpi/4.0.1

# The Slurm srun command has been replaced with the Flux equivalent.
flux run -n 16 /home/joshuapaul/vasp_10-23-19_5.4.4/bin/vasp_stand > job.log
echo Done

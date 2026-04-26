#!/bin/bash
#FLUX: --job-name=2740
#FLUX: --output=out.log
#FLUX: --error=err.log
#FLUX: --ntasks=16
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=6h

# The following SLURM directives could not be translated:
# --mem-per-cpu=1000mb
# --ntasks-per-socket=16

# The SLURM_SUBMIT_DIR variable is not needed; Flux starts in the submission directory.

module purge
module load intel/2019.1.144
module load openmpi/4.0.1

# The 'srun' command has been replaced with 'flux run'.
flux run /home/joshuapaul/vasp_10-23-19_5.4.4/bin/vasp_stand > job.log
echo Done

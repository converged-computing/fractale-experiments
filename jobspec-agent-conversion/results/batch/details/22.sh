#!/bin/bash
# A syntax error in the job name was corrected from `#SBATCH --job-name=2440#SBATCH` to `#SBATCH --job-name=2440`.
#FLUX: --job-name=2440
#FLUX: --output=out_%j.log
#FLUX: --error=err_%j.log
# The --qos=hennig directive is ignored as per instructions.
#FLUX: --ntasks=16
# The --ntasks-per-socket=16 directive has no direct flux analog and is omitted.
#FLUX: --tasks-per-node=16
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
# The --mem-per-cpu=1000mb directive has no direct flux analog and is omitted.
#FLUX: --time-limit=6h

# The SLURM_SUBMIT_DIR variable is replaced by FLUX_JOB_CWD
cd $FLUX_JOB_CWD

module purge
module load intel/2019.1.144
module load openmpi/4.0.1

# The srun command is replaced by `flux mini run`
flux mini run /home/joshuapaul/vasp_10-23-19_5.4.4/bin/vasp_stand > job.log
echo Done

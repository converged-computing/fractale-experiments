#!/bin/bash                      
#FLUX: --time-limit=11h59m
#FLUX: --nodes=1
#FLUX: --ntasks=2

# NOTE: The Slurm job array syntax with concurrency limit is not supported.
# You must submit this job with 'flux submit --cc=0-29 ...'

module load openmind/singularity/3.2.0        # load singularity module

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC.
singularity exec -B /om2,/om3  /om2/user/malleman/everything.simg python grammar_script.py $FLUX_JOB_CC   # Run the job steps

#!/bin/bash -login 
#FLUX: --nodes=1
#FLUX: --cores=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=10h59m
#FLUX: --job-name=1mk5_opp_yyy_xxx_uuu


# flux job info $FLUX_JOB_ID # Equivalent to qstat -f $PBS_JOBID
# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR

module load MATLAB-compiler/R2016a
./mtflex_opposite_parallel uuu yyy > out.txt

#!/bin/bash

# The -P, -q, -M, and -m directives are ignored as per instructions.
#FLUX: --job-name=array_job
# The PBS select statement is translated to the following flux directives:
#FLUX: --nodes=1
#FLUX: --cores=24
#FLUX: --output=/mnt/lustre/users/blombard/reinfectionsBelinda/oe_files/array_job_m1.out
#FLUX: --error=/mnt/lustre/users/blombard/reinfectionsBelinda/oe_files/array_job_m1.err
#FLUX: --time-limit=1h
# The PBS job array `-J 1-21:21` is not directly translatable. This script must be submitted
# with a manually stepped list of indices, e.g., `flux submit --cc=1,22,43,...`

sleep 4

#module add chpc/BIOMODULES R/4.1.0

# Add R module (includes appropriate openMPI and gcc modules)
module add chpc/R/3.5.1-gcc7.2.0

# make sure we're in the correct working directory.
cd /mnt/lustre/users/blombard/reinfectionsBelinda/

make sbv

STEP=21
# The PBS_ARRAY_INDEX is replaced with FLUX_JOB_CC.
START=$FLUX_JOB_CC
END=$(( $START+$STEP-1 ))

for i in $(eval echo "{$START..$END}")
do
	(echo "process $i started" && Rscript sbv/method_1_analysis/method_1_arrayjob.R $i && echo "process $i finished")& 
done

sleep 0.1 # For sequential output
echo "Waiting for processes to finish" 
wait $(jobs -p)
echo "All processes finished"

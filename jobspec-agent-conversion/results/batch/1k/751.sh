#!/bin/bash
#FLUX: -J rPGS
#FLUX: --nodes=1
#FLUX: -n 15
#FLUX: -t 8h
#FLUX: --output=./err/%A_%a.err

# Account, partition, and mail directives were ignored as per instructions.
# The filename substitutions %A and %a are not supported by Flux and will be treated literally.

. /etc/profile.d/modules.sh # Leave this line (enables the module command)
module purge                # Removes all modules still loaded
#module load default-impi    # REQUIRED - loads the basic environment
module load rhel7/default-peta4            # REQUIRED - loads the basic environment
module load r-4.0.2-gcc-5.4.0-xyx46xb
export I_MPI_PIN_ORDER=scatter # Adjacent domains have minimal sharing of caches/sockets

# Translated SLURM_JOB_ID to FLUX_JOB_ID
JOBID=$FLUX_JOB_ID
echo -e "JobID: $JOBID"

# Translated SLURM_ARRAY_TASK_ID to FLUX_JOB_CC
G=$FLUX_JOB_CC ### this is the array variable, you can use it the way you want. In this example I use it to select the gene based on the line number in a file
Rscript /home/gr440/rds/rds-cew54-basis/05-PGS/v3/code/rapidopgs_run_20210317.R  $G

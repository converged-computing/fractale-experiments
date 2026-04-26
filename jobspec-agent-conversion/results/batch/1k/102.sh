#!/bin/bash
#FLUX: --job-name=R_DXboots
#FLUX: --output=logs/%x_%j.out 
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --time=2h


# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.

## set the second environment variable to get the base directory
BASEDIR=$(pwd)



## set up a trap that will clear the ramdisk if it is not cleared
function cleanup_ramdisk {
    echo -n "Cleaning up ramdisk directory /$FLUX_JOB_ID/ on "
    date
    rm -rf /$FLUX_JOB_ID
    echo -n "done at "
    date
}

#trap the termination signal, and call the function 'trap_term' when
# that happens, so results may be saved.
trap "cleanup_ramdisk" TERM

module load R

mkdir -p /home/edickie/R/x86_64-pc-linux-gnu-library/4.1

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with a --cc flag.
Rscript ./code/R/running_bootedperm_DXeffects_PINTFC.R $FLUX_JOB_CC

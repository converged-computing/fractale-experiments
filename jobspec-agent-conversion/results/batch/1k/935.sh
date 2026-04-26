#!/usr/bin/env bash
#FLUX: --cores-per-task=1
#FLUX: --ntasks=1
#FLUX: --time-limit=1d
#FLUX: --job-name="CRISPIN"
#FLUX: --output="log/slurm_%j.log"

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.
# NOTE: The --parsable flag is not supported.


module load nextflow
NXF_SINGULARITY_CACHEDIR=/data/CCBR_Pipeliner/SIFS

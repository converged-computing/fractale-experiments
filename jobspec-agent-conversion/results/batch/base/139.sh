#!/bin/bash
#FLUX: -t 6h
#FLUX: --cores=12
#FLUX: --requires=intel
#FLUX: --cc=1-3

# NOTE: The Slurm directive '--mem=24G' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

sleep $((FLUX_JOB_CC*60))

set -e

export AGALMA_DB="/gpfs/data/cdunn/analyses/agalma-siphonophora-20170501_reduced.sqlite"

# NOTE: SLURM environment variables have been replaced. The requested CPU count is used for 'threads'.
# The memory variable has been removed due to the lack of a corresponding Flux directive.
export BIOLITE_RESOURCES="threads=12"

IDS=(
	dbEST_CLYHEM
	NCBI_HYDMAG
	JGI_NEMVEC
)

# The Slurm array task ID variable has been replaced with the Flux equivalent.
ID=${IDS[$FLUX_JOB_CC-1]}
echo $ID

agalma import --id $ID
agalma translate --id $ID


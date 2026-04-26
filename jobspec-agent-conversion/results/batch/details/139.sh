#!/bin/bash
#FLUX: --time-limit=6h
#FLUX: --cores=12
#FLUX: --requires=intel
#FLUX: --cc=1-3

sleep $((FLUX_JOB_CC*60))

set -e

export AGALMA_DB="/gpfs/data/cdunn/analyses/agalma-siphonophora-20170501_reduced.sqlite"

# The BIOLITE_RESOURCES variable is partially set. Flux does not have a direct
# equivalent for memory requests, so the memory part has been omitted.
# The thread count is set to the number of requested cores.
export BIOLITE_RESOURCES="threads=12"

IDS=(
	dbEST_CLYHEM
	NCBI_HYDMAG
	JGI_NEMVEC
)

ID=${IDS[$FLUX_JOB_CC-1]}
echo $ID

agalma import --id $ID
agalma translate --id $ID

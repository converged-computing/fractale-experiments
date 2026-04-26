#!/bin/sh
# roiFromPatch.sh - runs sparse PCA on a single patch specified by the data
#FLUX: --bank=hpcstats
#FLUX: --nodes=1
#FLUX: --time-limit=10h
#FLUX: --error=/hpc/stats/users/dbp2112/Janelia/logs/stderr.txt
#FLUX: --output=/hpc/stats/users/dbp2112/Janelia/logs/stdout.txt

# The PBS memory request 'mem=2gb' has no direct Flux analog in the provided documentation.
# The PBS -V directive is default behavior in Flux.
# NOTE: This script is intended for use as a Flux job collection (e.g., `flux submit --cc=...`)
# The original PBS_ARRAYID variable has been replaced with FLUX_JOB_CC.

/usr/local/bin/matlab-R2012b -r "addpath(genpath('/hpc/stats/users/dbp2112/Janelia/quagga')); roiFromPatch($FLUX_JOB_CC,'$config_path');"

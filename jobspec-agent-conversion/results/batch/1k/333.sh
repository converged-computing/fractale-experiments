#!/bin/sh
# The -W group_list=hpcstats directive is ignored.
# The PBS resource request is translated to the following flux directives:
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --time-limit=10h
# The mem=2gb directive has no direct flux analog and is omitted.
# The -V (export all environment variables) is the default behavior in Flux.
# The localhost: prefix for output files is not standard and has been removed.
#FLUX: --error=/hpc/stats/users/dbp2112/Janelia/logs/stderr.txt
#FLUX: --output=/hpc/stats/users/dbp2112/Janelia/logs/stdout.txt

# This script is a job array and must be submitted with `flux submit --cc=<range>`
# The PBS_ARRAYID variable is replaced with FLUX_JOB_CC for job arrays
/usr/local/bin/matlab-R2012b -r "addpath(genpath('/hpc/stats/users/dbp2112/Janelia/quagga')); roiFromPatch($FLUX_JOB_CC,'$config_path');"

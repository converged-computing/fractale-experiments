#!/bin/bash
# The group_list, -A, and -m directives are ignored as per instructions.
# The PBS resource request is translated to the following flux directives:
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
# The mem=16gb directive has no direct flux analog and is omitted.
#FLUX: --time-limit=70h
# The -N (job name) directive was empty and is omitted.
# This script is a job array and must be submitted with `flux submit --cc=0-20` (or the desired range)

# The PBS_O_WORKDIR variable is replaced by FLUX_JOB_CWD
cd $FLUX_JOB_CWD

arr=(rntrn_lamax rntrn_lamin rntrn_lamdv rntrn_labac rntrn_lasv rntrn_laev rntrn_lapev rntrn_latef rntrn_lapef rntrn_laaef rntrn_expansionidx rntrn_aeTangent rntrn_peTangent rntrn_lape_svd rntrn_ilamax rntrn_ilamin rntrn_ilamdv rntrn_ilabac rntrn_ilasv rntrn_ilaev rntrn_ilapev)
# The MOAB_JOBARRAYINDEX variable is replaced with FLUX_JOB_CC for job arrays
N=${arr[${FLUX_JOB_CC}]}

bash gwas_bolt_rtrn.sh $N

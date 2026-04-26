#!/bin/bash
#FLUX: --bank=cu_10039
# The -m n (no mail) directive is default behavior in Flux.
#FLUX: --nodes=1
#FLUX: --cores=10
#FLUX: --time-limit=70h

# The PBS memory request 'mem=16gb' has no direct equivalent in flux-submit.
# The job may fail due to insufficient memory.

# Job array range is assumed based on the script's array size.
#FLUX: --cc=0-20

# The 'cd $PBS_O_WORKDIR' command is not needed as Flux jobs start in the submission directory by default.

arr=(rntrn_lamax rntrn_lamin rntrn_lamdv rntrn_labac rntrn_lasv rntrn_laev rntrn_lapev rntrn_latef rntrn_lapef rntrn_laaef rntrn_expansionidx rntrn_aeTangent rntrn_peTangent rntrn_lape_svd rntrn_ilamax rntrn_ilamin rntrn_ilamdv rntrn_ilabac rntrn_ilasv rntrn_ilaev rntrn_ilapev)

# The MOAB_JOBARRAYINDEX variable is replaced by FLUX_JOB_CC
N=${arr[${FLUX_JOB_CC}]}


bash gwas_bolt_rtrn.sh $N

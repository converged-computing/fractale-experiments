#!/bin/bash
#FLUX: --time-limit=1d
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=16
#FLUX: --job-name=KM


module load MATLAB/R2019b

# create temporary directory and set it as MCR_CACHE_ROOT
export MCR_CACHE_ROOT=$(mktemp -d)

# KM_wrapper(fpath,k,delta_f_0,xi,a_max,n_a,f0_min,f0_max,n_f0,...
#   zeta,PRCfName,N,n_tr,n_pulses,dt,f_stim,freqSet,n_same,rndCycling)

# NOTE: Slurm job array syntax is not supported. This script assumes it is
# submitted as a unique job, using FLUX_JOB_ID as the unique identifier.
./run_KmWrapper.sh /system/software/linux-x86_64/matlab/R2019b "KM_"$FLUX_JOB_ID 350 20 7.9 20000 200 3 350 200 "[0 0.15]" "HH_PRC" 100 5 400 0.0001 130 "[]" 1 "false"
# wait for all processes to finish                        
wait 


# wait for all processes to finish                        
wait 

# remove temporary directories
rm -rf ${MCR_CACHE_ROOT}
#rm -rf ${MATLAB_JOB_TMP}

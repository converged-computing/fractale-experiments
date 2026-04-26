#!/bin/bash

#FLUX: --ntasks=1
#FLUX: --time-limit=4d
#FLUX: --job-name=Deep-RBM_DBM_5_inc_bin_PARAL_base
#FLUX: --error=Deep-RBM_DBM_5_inc_bin_PARAL_base.err.txt
#FLUX: --output=Deep-RBM_DBM_5_inc_bin_PARAL_base.out.txt

# The --mem-per-cpu=8000 directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

source /etc/profile.modules

module load gcc
module load matlab
cd ~/deepLearn && ./deepFunction 5 'RBM' 'DBM' '128   500  1000  1500    10' '0  1  1  1  1' '5_inc_bin' 'PARAL_base' "'iteration.n_epochs', 'learning.lrate', 'learning.cd_k', 'learning.persistent_cd', 'parallel_tempering.use'" '200 1e-3 1 0 1' "'iteration.n_epochs', 'learning.persistent_cd'" '200 1'

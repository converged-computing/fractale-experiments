#!/bin/bash

#FLUX: --ntasks=1
#FLUX: --time-limit=4d
#FLUX: --job-name=Deep-RBM_DBM_7_bot_bin_CD1_base
#FLUX: --error=Deep-RBM_DBM_7_bot_bin_CD1_base.err.txt
#FLUX: --output=Deep-RBM_DBM_7_bot_bin_CD1_base.out.txt
#FLUX: --cwd=~/deepLearn

source /etc/profile.modules

module load gcc
module load matlab
./deepFunction 7 'RBM' 'DBM' '128   500  1500  1000  2000   250    10' '0  1  1  1  1  1  1' '7_bot_bin' 'CD1_base' "'iteration.n_epochs', 'learning.lrate', 'learning.cd_k', 'learning.persistent_cd', 'parallel_tempering.use'" '200 1e-3 1 0 0' "'iteration.n_epochs', 'learning.persistent_cd'" '200 1'

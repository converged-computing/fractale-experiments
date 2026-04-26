#!/bin/bash

#FLUX: --ntasks=1
#FLUX: --time-limit=4d
#FLUX: --job-name=Deep-RBM_DBN_4_dec_real_PERS_base
#FLUX: --error=Deep-RBM_DBN_4_dec_real_PERS_base.err.txt
#FLUX: --output=Deep-RBM_DBN_4_dec_real_PERS_base.out.txt

# The SLURM directive '--mem-per-cpu=8000' could not be translated.

source /etc/profile.modules

module load gcc
module load matlab
cd ~/deepLearn

# The 'srun' command has been replaced with 'flux run'.
flux run ./deepFunction 4 'RBM' 'DBN' '128  1500  1000    10' '0  0  0  0' '4_dec_real' 'PERS_base' "'iteration.n_epochs', 'learning.lrate', 'learning.cd_k', 'learning.persistent_cd', 'parallel_tempering.use'" '200 1e-3 1 1 0' "'iteration.n_epochs', 'learning.persistent_cd'" '200 0'

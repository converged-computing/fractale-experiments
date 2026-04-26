#!/bin/bash

#FLUX: --queue=mono
#FLUX: --ntasks=1
#FLUX: --time-limit=4d
#FLUX: --job-name=Deep-DAE_SDAE_4_lin_real_RICA_sig
#FLUX: --error=Deep-DAE_SDAE_4_lin_real_RICA_sig.err.txt
#FLUX: --output=Deep-DAE_SDAE_4_lin_real_RICA_sig.out.txt

# The SLURM --mem-per-cpu directive has no direct Flux analog in the provided documentation.

source /etc/profile.modules

module load gcc
module load matlab

# The srun command is removed as this is not a parallel (MPI) application.
cd ~/deepLearn && ./deepFunction 4 'DAE' 'SDAE' '128  1500  1500    10' '0  0  0  0' '4_lin_real' 'RICA_sig' "'iteration.n_epochs', 'learning.lrate', 'use_tanh', 'noise.drop', 'noise.level', 'rica.cost', 'cae.cost'" '200 1e-3 0 0 0 0.1 0' "'iteration.n_epochs', 'use_tanh'" '200 0'

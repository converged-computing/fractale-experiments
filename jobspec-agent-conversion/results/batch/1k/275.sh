#!/bin/bash
#FLUX: -n 600
#FLUX: --tasks-per-node=40
#FLUX: --output=%J.out
#FLUX: --error=%J.err

# The LSF directive '-R "span[ptile=40]"' was translated to --tasks-per-node=40.
# The LSF queue '-q large' was ignored as per instructions.

#-------------intelmpi+ifort------------------------------------------
source /share/intel/2018u4/compilers_and_libraries/linux/bin/compilervars.sh -arch intel64 -platform linux
source /share/intel/2018u4/impi/2018.4.274/intel64/bin/mpivars.sh
source /share/apps/anaconda3/2020.7/conda_env.sh
conda activate pytorch

# The command is now launched using 'flux mini run' to correctly use the allocated resources.
flux mini run -n 600 python tenpy_dmrg_generate_data_100bit.py
#---------------------------------------------------------------------

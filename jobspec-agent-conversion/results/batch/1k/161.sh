#!/bin/bash
#
#FLUX: --nodes=1
#FLUX: --cores=2
#FLUX: --time-limit=1d
#FLUX: --output=../logfile/CI_Tau_h50_e40_a-10_lines.out

# NOTE: The -j oe (join output/error) option is not supported.


# cd $PBS_O_WORKDIR # This is the default behavior in Flux
module load anaconda3/2022.05-gcc/9.5.0
echo "Loaded"

python calculate_lines.py
echo "Completed"

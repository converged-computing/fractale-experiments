#!/bin/bash
#FLUX: --job-name=Act_tanh_1
# The --mail-user and --mail-type directives are ignored.
#FLUX: --error=/work/scratch/se55gyhe/log/output.err.%j
#FLUX: --output=/work/scratch/se55gyhe/log/output.out.%j
#FLUX: --ntasks=1
# The --mem-per-cpu=6000 directive has no direct flux analog and is omitted.
#FLUX: --time-limit=23h59m

#module load intel python/3.5

python3 /home/se55gyhe/Act_func/sequence_tagging/arg_min/G2P-my_LSTM-act1_save_new_odd.py tanh 50 Adamax 1 0.32873413360732373 0.002314007172161447 orth 1.0 efile.norm.3_5 odd_G2P_3_5/

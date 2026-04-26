#!/bin/bash
 
#FLUX: --job-name=Act_tanh_1
#FLUX: --error=/work/scratch/se55gyhe/log/output.err
#FLUX: --output=/work/scratch/se55gyhe/log/output.out
#FLUX: --ntasks=1
#FLUX: --time-limit=23h59m

#module load intel python/3.5

python3 /home/se55gyhe/Act_func/sequence_tagging/arg_min/G2P-my_LSTM-act1_save_new_odd.py tanh 50 Adamax 1 0.32873413360732373 0.002314007172161447 orth 1.0 efile.norm.7_4 odd_G2P_7_4/

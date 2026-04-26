#!/bin/bash
 
#FLUX: --job-name=Act_elu_1
#FLUX: --error=/work/scratch/se55gyhe/log/output.err.%j
#FLUX: --output=/work/scratch/se55gyhe/log/output.out.%j
#FLUX: --ntasks=1
#FLUX: --time-limit=23h59m

# The --mem-per-cpu=2000 directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output and --error directives do not support Slurm-style job ID substitution (%j).

#module load intel python/3.5

python3 /home/se55gyhe/Act_func/progs/meta.py elu 1 Adamax 3 0.20543703433054028 51 0.002160465815151414 lecun_uniform PE-infersent 



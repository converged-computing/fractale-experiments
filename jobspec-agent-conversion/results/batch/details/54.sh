#!/bin/bash
#
# The --account=normal and -p gpu directives are ignored as per instructions.
#
#FLUX: --job-name=elp
#
## output files
#FLUX: --output=logs/output-ep-pr-%j.log
#FLUX: --error=logs/output-ep-pr-%j.err
#
# Estimated running time. 
# The job will be killed when it runs 15 min longer than this time.
#FLUX: --time-limit=1d
# The --mem=50gb directive has no direct flux analog and is omitted.
#
## Resources 
## -p gpu/batch  |job type
## -N            |number of nodes
## -n            |number of cpu 
#FLUX: --nodes=2
#FLUX: --ntasks=2
# The --exclude=pgpu01 directive has no direct flux analog and is omitted.

ulimit -c 256
nvidia-smi
source activate lipinggpu
stdbuf -o0 python -u run-exp.py kegg_20_maccs -m ep -e pr --random_seed 1997

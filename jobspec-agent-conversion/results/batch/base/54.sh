#!/bin/bash
#
#FLUX: -B normal
#
#FLUX: --job-name=elp
#
## output files
#FLUX: --output=logs/output-ep-pr-{flux:jobid}.log
#FLUX: --error=logs/output-ep-pr-{flux:jobid}.err
#
# Estimated running time.
#FLUX: -t 1d
# NOTE: The SLURM directive '--mem=50gb' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
#
## Resources
#FLUX: -q gpu
#FLUX: --nodes=2
#FLUX: --ntasks=2
# NOTE: The SLURM directive '--exclude=pgpu01' was omitted as there is no direct Flux equivalent.
# This may result in the job being scheduled on the excluded node.

ulimit -c 256
nvidia-smi
source activate lipinggpu
stdbuf -o0 python -u run-exp.py kegg_20_maccs -m ep -e pr --random_seed 1997


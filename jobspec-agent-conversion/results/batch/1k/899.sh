#!/bin/bash
#FLUX: --job-name=shb-test-jobs
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=2
#FLUX: --time-limit=2h
#FLUX: --output=test.out
#FLUX: --error=test.out


# cd "$SLURM_SUBMIT_DIR" # This is the default behavior in Flux
echo "Running in $(pwd):"

set -x

. ./mfc.sh load -c p -m GPU

gpu_count=$(nvidia-smi -L | wc -l)        # number of GPUs on node
gpu_ids=$(seq -s ' ' 0 $(($gpu_count-1))) # 0,1,2,...,gpu_count-1

./mfc.sh test -a -j 2 --gpu -g $gpu_ids -- -c phoenix

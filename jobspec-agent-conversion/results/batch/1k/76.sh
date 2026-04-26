#!/bin/bash
#FLUX: --job-name=pytorch-bench
#FLUX: --nodes=1
#FLUX: --cores=8
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=12h

# The -q (queue) directive was ignored as per instructions.
# The cd to $PBS_O_WORKDIR was removed as Flux starts in the submission directory by default.

set -eu

module purge
module load cray-python/3.9.4.2
module list

#source venv-torch1121/bin/activate
source venv-torch1121-cuda102/bin/activate

count=`nvidia-smi --query-gpu=name --format=csv,noheader | wc -l`
echo count $count
count=1

echo 'start'
for (( c=$count; c>=1; c-- ))
do
      python3 benchmark_models.py -g $c&& &>/dev/null
done
echo 'end'

#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores=1
#FLUX: --gpus-per-node=1
#FLUX: --requires=gtx1080ti
#FLUX: -t 1h59m
#FLUX: -B "SDwithToMe"

# NOTE: The PBS directive 'mem=15gb' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.

set -e

module load PyTorch/1.13.0

export PIP_CONFIG_FILE=/software/python/pip.conf

cd /gpfs/project/hebal100/ba-code

python -m pip install --user -r scripts/requirements.txt

python src/logging/gen_fid_log.py 'data/run3_768x768'

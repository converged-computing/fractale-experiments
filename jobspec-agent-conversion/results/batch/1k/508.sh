#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --requires=gtx1080ti
#FLUX: --time-limit=1h59m

# The PBS directive for memory ('-l mem=15gb') could not be translated.

set -e

module load PyTorch/1.13.0

export PIP_CONFIG_FILE=/software/python/pip.conf

cd /gpfs/project/hebal100/ba-code

python -m pip install --user -r scripts/requirements.txt

python src/logging/gen_fid_log.py 'data/run3_768x768'

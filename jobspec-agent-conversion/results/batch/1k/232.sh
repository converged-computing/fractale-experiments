#!/bin/bash -v
#FLUX: --job-name=dae-cz
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1d


module add python-3.6.2-gcc
module add python36-modules-gcc
module add cuda-10.0
module add cudnn-7.0

# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR

source scripts/venv.sh
export PYTHONPATH=/storage/plzen1/home/memduh/versetorch/venv/
export PYTHON=/storage/plzen1/home/memduh/versetorch/venv/bin/python
$PYTHON src/train/dae_acc.py --dataset cz

#!/bin/bash
#FLUX: --job-name=eacikgoz17_exp8_tur
#FLUX: --nodes=1
#FLUX: --tasks-per-node=2
#FLUX: --gpus-per-node=1
#FLUX: --requires=tesla_t4
#FLUX: --time-limit=7d
#FLUX: --output=test.out

echo "Setting stack size to unlimited..."
ulimit -s unlimited
ulimit -l unlimited
ulimit -a
echo

module load anaconda/3.6
source activate eacikgoz17
nvidia-smi
python main_tur.py 

source deactivate

#!/bin/bash
#FLUX: --job-name=eacikgoz17_exp8_tur
#FLUX: --nodes=1
#FLUX: --ntasks=2
#FLUX: --queue=ai
#FLUX: --bank=ai
#FLUX: --gpus-per-node=1
#FLUX: --requires=tesla_t4
#FLUX: --time-limit=7d
#FLUX: --output=test-{id}.out

# The --mem=20G parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.
# The --qos, --mail-type, and --mail-user parameters from slurm have no direct equivalent in flux-submit.


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

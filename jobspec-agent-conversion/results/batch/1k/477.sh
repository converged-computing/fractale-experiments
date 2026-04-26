#!/bin/bash --login
#FLUX: --job-name=RM
#FLUX: --output=o.%x.%j
#FLUX: --error=e.%x.%j
# The -p (partition) and --account directives are ignored.
# The --gres=gpu:2 directive is translated to --gpus-per-node=2 as only 1 node is requested.
#FLUX: --nodes=1
#FLUX: --gpus-per-node=2
#FLUX: --ntasks=8
#FLUX: --time-limit=6h

git pull origin dev-train 
module purge
module load deepspeed
module list
export PYTHONPATH="${PYTHONPATH}:/home/c.scmse/Funtuner"
exec singularity exec --nv $DEEPSPEED_IMAGE /nfshome/store03/users/c.scmse/venv/bin/python3 funtuner/trainer.py

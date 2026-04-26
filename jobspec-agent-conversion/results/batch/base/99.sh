#!/bin/bash --login
#FLUX: --job-name=RM
#FLUX: --output=o.{{job-name}}.{{id}}
#FLUX: --error=e.{{job-name}}.{{id}}
#FLUX: --queue=gpu_v100
#FLUX: --nodes=1
#FLUX: --ntasks=8
#FLUX: --gpus-per-node=2
#FLUX: --time-limit=6h
#FLUX: --bank=scw2050

git pull origin dev-train
module purge
module load deepspeed
module list
export PYTHONPATH="${PYTHONPATH}:/home/c.scmse/Funtuner"
exec singularity exec --nv $DEEPSPEED_IMAGE /nfshome/store03/users/c.scmse/venv/bin/python3 funtuner/trainer.py

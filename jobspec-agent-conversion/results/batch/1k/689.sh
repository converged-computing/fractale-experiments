#!/bin/bash
#FLUX: --job-name=siren
#FLUX: --ntasks=1
#FLUX: --tasks-per-node=1
#FLUX: --gpus-per-node=1
#FLUX: --cores-per-task=10
#FLUX: --time-limit=100h
#FLUX: --output=slurm_run/burgers/siren-{id}.out
#FLUX: --error=slurm_run/burgers/siren-{id}.err

set -x

module purge
module load pytorch-gpu/py3/1.10.1 # pytorch-gpu/py3/1.5.0

dataset_name="burgers"
run_name="tough-puddle-24"

python3 -m training.create_modulations "functa.dataset_name=${dataset_name}" "functa.run_name=${run_name}"

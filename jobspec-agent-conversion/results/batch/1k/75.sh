#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=32
#FLUX: --time-limit=24h
#FLUX: --gpus-per-node=1
#FLUX: --output=<ANONYMOUS>/<ANONYMOUS>/sysevr/jobs/logs/model_trainer.out
#FLUX: --error=<ANONYMOUS>/<ANONYMOUS>/sysevr/jobs/logs/model_trainer.err
#FLUX: --job-name="Model Trainer"

module load  python/3.6.5-fwk5uaj
module load tensorflow-gpu/1.2.1/u16-cuda8.0-libcudnn5.1-py36

path=<ANONYMOUS>/<ANONYMOUS>/sysevr/Implementation/model
cd $path

tf-gpu python bgru.py

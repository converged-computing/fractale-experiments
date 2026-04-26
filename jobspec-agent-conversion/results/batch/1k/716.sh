#!/bin/bash
#FLUX: --time-limit=15m
#FLUX: --nodes=4
#FLUX: --ntasks-per-node=4
#FLUX: --gpus-per-node=4
#FLUX: --cores-per-task=32
#FLUX: --ntasks=16


export HDF5_USE_FILE_LOCKING=FALSE
export MASTER_ADDR=$(hostname)

launch="python inference/inference_ensemble.py --config=afno_backbone_finetune --run_num=0 --n_level=0.3"
#launch="python inference/inference_ensemble_precip.py --config=precip --run_num=1 --n_level=0.1"

# srun is replaced with 'flux run'. The shifter command is wrapped in a bash shell.
flux run -n 16 shifter --image=nersc/pytorch:ngc-22.02-v0 --module=gpu --env PYTHONUSERBASE=$HOME/.local/perlmutter/nersc-pytorch-22.02-v0 bash -c "
    source export_DDP_vars.sh
    $launch
    "

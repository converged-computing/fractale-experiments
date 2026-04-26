#!/usr/bin/env bash
#FLUX: -t 1d10h
#FLUX: -g 1
#FLUX: -c 5
#FLUX: -n 1

# The SLURM partition directive '-p small' was ignored as per instructions.

set -ex

NPROC=$(nproc)
if [[ $NPROC -ge 10 ]]; then
    WORKERS=$(($NPROC / 2))
else
    WORKERS=$NPROC
fi

nvidia-smi
env | sort
python main.py jester RGB \
    --workers $WORKERS \
    $ARGS \
    "$@"

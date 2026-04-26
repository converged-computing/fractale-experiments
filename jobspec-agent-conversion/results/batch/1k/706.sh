#!/bin/bash
#FLUX: --time-limit=24h
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=2
#FLUX: --ntasks=2
#FLUX: --cores-per-task=1

MAX_SEED=$1
DATASET=$2
HP_SAMPLING=$3
CONTAMINATION=$4

module load Julia/1.5.1-linux-x86_64
module load Python/3.8.2-GCCcore-9.3.0

julia ./gan.jl ${MAX_SEED} $DATASET ${HP_SAMPLING} $CONTAMINATION


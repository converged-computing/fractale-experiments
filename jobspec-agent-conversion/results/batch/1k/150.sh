#!/bin/bash
#FLUX: --gpus-per-task=1
#FLUX: -t 56h
#FLUX: -n 1
#FLUX: --cores-per-task=1
#FLUX: --job-name="trmor2006_full_dis"
#FLUX: --output=trmor2006_full_dis.out
#FLUX: --error=trmor2006_full_dis.error

# The SLURM directive '--mem-per-cpu=32GB' was omitted as it has no direct Flux translation.
# The SLURM directives for partition, account, and qos were ignored as per instructions.

echo "julia main.jl --dataSet TRDataSet --version 2016 --epochs 100 --lemma --dropouts 0.3 --modelType MorseDis"
julia main.jl --dataSet TRDataSet --version 2016 --epochs 100 --lemma --dropouts 0.3 --modelType MorseDis

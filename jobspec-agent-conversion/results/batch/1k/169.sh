#!/bin/bash
#FLUX: --job-name=amber_bench_cuda
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --time-limit=24h
#FLUX: --output=fy_minst_train.log
#FLUX: --gpus-per-task=1


echo "Running gaussian-test on $SLURM_CPUS_ON_NODE CPU cores"

python Dropout_Simple_CIFAR6_Berrnoulli_Measurement.py


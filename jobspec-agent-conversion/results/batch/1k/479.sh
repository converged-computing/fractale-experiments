#!/bin/bash

#FLUX: --job-name="Train German Credit (ECCCo)"
#FLUX: --time-limit=1h
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=1


# srun is not required for a single task job in Flux
julia --project=experiments experiments/run_experiments.jl -- data=german_credit output_path=results only_models > experiments/train_german_credit.log

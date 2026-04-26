#!/bin/bash
#FLUX: --job-name=multinomial
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=2d
#FLUX: --output=/home/b.weinstein/logs/DeepTreeAttention_%j.out
#FLUX: --error=/home/b.weinstein/logs/DeepTreeAttention_%j.err


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

source activate DeepTreeAttention

cd ~/DeepTreeAttention/
python sample_multinomial.py

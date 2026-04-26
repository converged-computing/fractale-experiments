#!/bin/bash
#FLUX: --ntasks=4
#FLUX: --gpus-per-task=1
#FLUX: --output=logs/%x_%u_%j.out
#FLUX: --error=logs/%x_%u_%j.err

python metric_learning.py --arch-type siamese --epochs 200 --process eval

#!/bin/bash

#FLUX: --time-limit=1h50m
#FLUX: --nodes=8
#FLUX: --tasks-per-node=2
#FLUX: --cores-per-task=16

ulimit -a
module load Python/3.6.3-foss-2017b
source hdis/bin/activate

flux mini run -n 16 python keras-cifar10-resnet.py

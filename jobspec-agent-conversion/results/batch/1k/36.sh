#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks-per-node=8
#FLUX: --ntasks=8
#FLUX: --time=5m
#FLUX: --job-name=TensorFlowTest
#FLUX: -o TensorFlowTest.o%j

# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.


module load gcc/4.9.1 cuda/8.0 cudnn/5.1 python3/3.5.2 tensorflow-gpu/1.0.0

python3 /home/05268/junma7/TensorFlow-Examples/examples/2_BasicModels/random_forest.py 

#!/bin/bash

#FLUX: --nodes=3
#FLUX: --ntasks-per-node=8
#FLUX: --ntasks=24
#FLUX: --time-limit=1h
#FLUX: --job-name=TensorFlowTest
#FLUX: --output=TensorFlowTest.out

module load gcc/4.9.1 cuda/8.0 cudnn/5.1 python3/3.5.2 tensorflow-gpu/1.0.0

python3 /home/05268/junma7/facialExpression/cnn_tf.py 

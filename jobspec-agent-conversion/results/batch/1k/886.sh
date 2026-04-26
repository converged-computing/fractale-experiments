#!/bin/bash -l
#FLUX: -t 10
#FLUX: -n 1

# The Cobalt directive '--attrs filesystems=home,theta-fs0' was omitted as it has no direct Flux translation.

module load conda/2022-07-01
conda activate

python 12_tensorflow_mnist.py

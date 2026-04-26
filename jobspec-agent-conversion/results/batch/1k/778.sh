#!/bin/bash

#FLUX: --job-name=histo-smearing
#FLUX: --output=slurm_histo_smearing.out
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=48h

# The --mem=32GB directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

# Modules
module purge
module load jupyter-kernels/py2.7
module load scikit-learn/intel/0.18.1
# module load theano/0.9.0
# module load tensorflow/python2.7/20170707
# module load keras/2.0.2

cd /home/jb6504/higgs_inference/higgs_inference

python -u experiments.py histo --smearing --neyman -x 1 41 -o neyman2 asymmetricbinning

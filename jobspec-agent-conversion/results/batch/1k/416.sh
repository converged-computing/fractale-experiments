#!/bin/bash
# Your job will use 1 node, 28 cores, and 168gb of memory total.
#FLUX: --nodes=1
#FLUX: --cores=28
#FLUX: --job-name=rnn_pretrained
#FLUX: --time-limit=12h
#FLUX: --error=/home/u25/dongfangxu9/umls/log/error/twa_test
#FLUX: --output=/home/u25/dongfangxu9/umls/log/output/twa_test

# The following PBS directives could not be translated:
# -l mem=168gb (total memory)
# -l pcmem=8gb (physical memory per core)
# -l place=pack:exclhost (placement policy)
# -l cput=336:00:00 (CPU time)
# This may impact job scheduling, resource allocation, and performance.

#####module load cuda80/neuralnet/6/6.0
#####module load cuda80/toolkit/8.0.61
module load singularity/3.2.1

singularity exec --nv /extra/dongfangxu9/image_bert/hpc-ml_centos7-python37.sif python3.7

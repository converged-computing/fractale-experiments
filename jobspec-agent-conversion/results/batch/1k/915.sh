#!/usr/bin/env bash
#FLUX: --cores-per-task=128
#FLUX: --output=/users2/kustera/log/nlp_out_exp4_brown.txt
#FLUX: --error=/users2/kustera/log/nlp_err_exp4_brown.txt
#FLUX: --time-limit=4h
#FLUX: --gpus-per-task=2
#FLUX: --requires=amdv100

# The --mem 500G directive has no direct analog in the provided flux submit options.
# This will likely impact job scheduling and resource allocation.
# The GPU request was inferred from the partition name and the python script's arguments.

module load python/3.7.2
module load CMake
module load GCC
source ~/.bashrc

conda activate dev
cd ~/uw-nlp && python3 pos/pos.py --model BILSTM_CRF --dataset BROWN --traincasetype CASED --devcasetype CASED --testcasetype TRUECASE --embedding ELMO --batchsize 1024 --epochs 40 --learningrate 1e-3 --lstmhiddenunits 512 --lstmdropout 0.0 --lstmrecdropout 0.0 --numgpus 2

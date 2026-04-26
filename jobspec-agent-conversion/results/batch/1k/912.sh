#!/usr/bin/env bash
#FLUX: --cores=128
#FLUX: --output=/users2/kustera/log/nlp_out_exp_add_cc_2.txt
#FLUX: --error=/users2/kustera/log/nlp_err_exp_add_cc_2.txt
#FLUX: --time-limit=4h

module load python/3.7.2
module load CMake
module load GCC
source ~/.bashrc

conda activate dev
cd ~/uw-nlp && python3 pos/pos.py --model BILSTM_CRF --dataset PTB --traincasetype CASED --devcasetype CASED --testcasetype CASED --embedding GLOVE --batchsize 1024 --epochs 40 --learningrate 1e-3 --lstmhiddenunits 512 --lstmdropout 0.0 --lstmrecdropout 0.0 --numgpus 2

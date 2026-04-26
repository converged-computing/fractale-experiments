#!/usr/bin/env bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=128
# The --mem 500G directive has no direct flux analog and is omitted.
#FLUX: --output=/users2/kustera/log/nlp_out_exp_add_hmu_3.txt
#FLUX: --error=/users2/kustera/log/nlp_err_exp_add_hmu_3.txt
#FLUX: --time-limit=4h
# The --partition amdv100 directive is ignored as per instructions.
# The application call specifies --numgpus 2, so this is translated to a flux directive.
#FLUX: --gpus-per-task=2

module load python/3.7.2
module load CMake
module load GCC
source ~/.bashrc

conda activate dev
cd ~/uw-nlp && python3 pos/pos.py --model BILSTM --dataset PTB --traincasetype HALF_MIXED --devcasetype HALF_MIXED --testcasetype UNCASED --embedding ELMO --batchsize 1024 --epochs 40 --learningrate 1e-3 --lstmhiddenunits 512 --lstmdropout 0.0 --lstmrecdropout 0.0 --numgpus 2

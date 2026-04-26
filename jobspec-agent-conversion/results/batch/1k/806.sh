#!/bin/bash
#FLUX: --job-name=sim10b
#FLUX: --output=/hits/basement/nlp/fatimamh/outputs/hipo/exp10/out-%j 
#FLUX: --error=/hits/basement/nlp/fatimamh/outputs/hipo/exp10/err-%j
#FLUX: --time-limit=14d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --gpus-per-task=1


module load CUDA/10.0.130

. /home/fatimamh/anaconda3/etc/profile.d/conda.sh
conda activate kis
python /hits/basement/nlp/fatimamh/codes/keep_it_simple/run_keep_it_simple.py -d /hits/basement/nlp/fatimamh/outputs/hipo/exp10/wiki_mono_test-pacsum_bert-cos-order

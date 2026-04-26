#!/bin/bash
#FLUX: --job-name=sim8b
#FLUX: --output=/hits/basement/nlp/fatimamh/outputs/hipo/exp08/out-%J
#FLUX: --error=/hits/basement/nlp/fatimamh/outputs/hipo/exp08/err-%J
#FLUX: --time-limit=14d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --gpus-per-task=1

module load CUDA/10.0.130

. /home/fatimamh/anaconda3/etc/profile.d/conda.sh
conda activate kis
python /hits/basement/nlp/fatimamh/codes/keep_it_simple/run_keep_it_simple.py -d /hits/basement/nlp/fatimamh/outputs/hipo/exp08/wiki_mono_test_no_sections-rand_20-cos-order-add_f=0.0_b=1.0_s=1.0

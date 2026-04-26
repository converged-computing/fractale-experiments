#!/bin/bash
#FLUX: --job-name=sim3c
#FLUX: --output=/hits/basement/nlp/fatimamh/outputs/hipo/exp03/out-{id}
#FLUX: --error=/hits/basement/nlp/fatimamh/outputs/hipo/exp03/err-{id}
#FLUX: --time-limit=14d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --queue=pascal-deep.p

module load CUDA/10.0.130

. /home/fatimamh/anaconda3/etc/profile.d/conda.sh
conda activate kis
python /hits/basement/nlp/fatimamh/codes/keep_it_simple/run_keep_it_simple.py -d /hits/basement/nlp/fatimamh/outputs/hipo/exp03/wiki_mono_test-rand_200-cos-edge-add_f=0.0_b=1.0_s=0.5

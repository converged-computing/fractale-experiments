#!/bin/bash
#FLUX: --job-name=run_eval
#FLUX: --cores-per-task=60
#FLUX: --ntasks=1
#FLUX: --time-limit=2h30m
#FLUX: --tasks-per-node=1
#FLUX: --gpus-per-node=1
#FLUX: --nodes=1
#FLUX: --exclusive
#FLUX: --output=logs/toxicity-eval-run_eval.out
#FLUX: --error=logs/toxicity-eval-run_eval.err
set -x

rm -f logs/latest.out logs/latest.err
ln -s toxicity-eval-$FLUX_JOB_NAME-$FLUX_JOB_ID.out logs/latest.out
ln -s toxicity-eval-$FLUX_JOB_NAME-$FLUX_JOB_ID.err logs/latest.err


export NCCL_SOCKET_IFNAME=hsn
export CACHE_DIR=/scratch/project_462000185/risto/huggingface-t5-checkpoints/cache_dir/
export TRANSFORMERS_OFFLINE=1

module load cray-python
export PYTHONUSERBASE="."
source /scratch/project_462000119/risto/venv/bin/activate
TF_CPP_MIN_LOG_LEVEL=0 

python3 toxicity_eval.py \
    --tokenizer "bert-base-finnish-cased-v1" \
    --data $1 \
    --model "finbert-large-deepl/" \



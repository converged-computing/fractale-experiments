#!/bin/bash
#FLUX: --queue=gLiotq
#FLUX: --nodes=1
#FLUX: --cores-per-task=8
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --output=$FLUX_JOB_ID.out
#FLUX: --error=$FLUX_JOB_ID.err

# The PBS memory request 'mem=64G' has no direct Flux analog in the provided documentation.
# The PBS '-v DOCKER_IMAGE=...' directive is site-specific and has no direct Flux analog.
# The PBS '-k doe' and '-j oe' directives for output file handling have been simplified to separate output/error files.

echo "a"

# Flux jobs start in the submission directory by default.

TORCH_HOME=`pwd`/.cache/torch
TRANSFORMERS_CACHE=`pwd`/.cache/transformers
HF_HOME=`pwd`/.cache/huggingface
export TORCH_HOME TRANSFORMERS_CACHE HF_HOME
export TORCH_USE_CUDA_DSA=1

poetry run accelerate launch --mixed_precision=bf16 src/train_emo_polarity_fine.py \
    --model_name rinna/japanese-gpt-neox-3.6b \
    --batch_size 32 --epochs 2 --learning_rate 1e-5 \
    --output_dir "/work/n213304/learn/anime_retweet_2/work_emo_analyze/llm-lora-classification/outputs/rinna__japanese-gpt-neox-3.6b"

#!/bin/bash
# The -q gLiotq (queue) directive is ignored as per instructions.
#FLUX: --nodes=1
#FLUX: --cores-per-task=8
#FLUX: --ntasks=1
# The mem=64G directive has no direct flux analog and is omitted.
#FLUX: --gpus-per-task=1
# The -v DOCKER_IMAGE=... directive is a site-specific containerization feature
# and has no direct Flux analog. The job will not run in the specified container.
# The -k doe -j oe directives for joining output/error are handled by specifying 
# the same file for both --output and --error, if a specific file were named.

echo "a"

# The PBS_O_WORKDIR variable is replaced by FLUX_JOB_CWD
cd ${FLUX_JOB_CWD}

TORCH_HOME=`pwd`/.cache/torch
TRANSFORMERS_CACHE=`pwd`/.cache/transformers
HF_HOME=`pwd`/.cache/huggingface
export TORCH_HOME TRANSFORMERS_CACHE HF_HOME
export TORCH_USE_CUDA_DSA=1

poetry run accelerate launch --mixed_precision=bf16 src/train_emo_polarity_fine.py \
    --model_name rinna/japanese-gpt-neox-3.6b \
    --batch_size 32 --epochs 2 --learning_rate 1e-5 \
    --output_dir "/work/n213304/learn/anime_retweet_2/work_emo_analyze/llm-lora-classification/outputs/rinna__japanese-gpt-neox-3.6b"

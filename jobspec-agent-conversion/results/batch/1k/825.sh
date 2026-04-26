#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores=8
#FLUX: --gpus-per-node=1

# The following PBS directives could not be translated:
# -l mem=64G (memory request)
# -j oe (join stdout/stderr)
# -v DOCKER_IMAGE (container image)
# This may impact job scheduling, resource allocation, and execution environment.

# The -q (queue) directive was ignored as per instructions.


TORCH_HOME=`pwd`/.cache/torch
TRANSFORMERS_CACHE=`pwd`/.cache/transformers
HF_HOME=`pwd`/.cache/huggingface
export TORCH_HOME TRANSFORMERS_CACHE HF_HOME
export TORCH_USE_CUDA_DSA=1

poetry run accelerate launch --mixed_precision=bf16 src/train.py --model_name rinna/japanese-gpt-neox-3.6b

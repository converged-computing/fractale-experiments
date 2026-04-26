#!/bin/bash
#FLUX: --job-name=BWC
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=15m
#FLUX: --output=out/log-%x-%j.out

# The --mem-per-cpu=32G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output directive does not support Slurm-style job name/ID substitution.
# The output filename will be literally 'out/log-%x-%j.out'.

module load  StdEnv/2020  cuda cudnn
module load gcc opencv

nvidia-smi

source  ../../../ENV/bin/activate

echo "Testing..."

python -u ./train_eval.py ./configs/BWC.yaml --output BWC_out 2>&1 | tee BWC_out.log

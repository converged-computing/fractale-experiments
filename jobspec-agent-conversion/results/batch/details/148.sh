#!/bin/sh
# The -q gpua100 (queue) directive is ignored.
# The -gpu "num=2" directive is translated to --gpus-per-task=2 for a single-task job.
#FLUX: --gpus-per-task=2
#FLUX: --job-name="Train ResNeSt"
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --time-limit=24h
# The -R "rusage[mem=32GB]" directive has no direct flux analog and is omitted.
#FLUX: --output=logs/%j.out
#FLUX: --error=logs/%j.err

module load python3/3.7.10
module load cuda/11.5
module load cudnn
module load ffmpeg

pip3 install torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html

echo "Running script..."
make train

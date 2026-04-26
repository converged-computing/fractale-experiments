#!/bin/sh
#FLUX: --queue=gpua100
#FLUX: --gpus-per-task=2
#FLUX: --job-name="Train ResNeSt"
#FLUX: --ntasks=1
#FLUX: --time-limit=24h
#FLUX: --output=logs/{id}.out
#FLUX: --error=logs/{id}.err

# The LSF memory request (-R "rusage[mem=32GB]") has no direct Flux analog in the provided documentation.

module load python3/3.7.10
module load cuda/11.5
module load cudnn
module load ffmpeg

pip3 install torch==1.9.1+cu111 torchvision==0.10.1+cu111 torchaudio==0.9.1 -f https://download.pytorch.org/whl/torch_stable.html

echo "Running script..."
make train

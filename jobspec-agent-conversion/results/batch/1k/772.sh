#!/bin/bash
#FLUX: --job-name=rnnvae
#FLUX: --cwd=/homedtic/gmarti/CODE/RNN-VAE
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --output=LOGS/vae1_{id}.out
#FLUX: --error=LOGS/vae1_{id}.err

source /etc/profile.d/lmod.sh
source /etc/profile.d/easybuild.sh
# source activate dlnn38

#source activate /homedtic/gmarti/ENV/dl38
module load Python
module --ignore-cache load CUDA/10.2.89
module --ignore-cache load cuDNN/7.6.5.32-CUDA-10.2.89
source /homedtic/gmarti/pytorch/bin/activate 

python scripts_mc/metaexp_synth_pad.py

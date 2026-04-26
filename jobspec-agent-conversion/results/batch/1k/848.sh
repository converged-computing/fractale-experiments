#!/bin/bash
#FLUX: --job-name=pet
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=72h
#FLUX: --error=/home/mila/c/chris.emezue/pet-masakhane-news/slurm/slurmerror_pet_install.txt
#FLUX: --output=/home/mila/c/chris.emezue/pet-masakhane-news/slurm/slurmoutput_pet_install.txt
#FLUX: --cwd=/home/mila/c/chris.emezue/pet-masakhane-news


module load python/3
module load cuda/11.0/cudnn/8.0
source /home/mila/c/chris.emezue/scratch/pet-env/bin/activate

pip install --upgrade pip
pip install torch==1.7.1+cu110 torchvision==0.8.2+cu110 torchaudio==0.7.2 -f https://download.pytorch.org/whl/torch_stable.html
pip install -r requirements.txt


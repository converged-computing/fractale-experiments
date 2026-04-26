#!/bin/bash
#FLUX: --job-name=task_3
#FLUX: --output=task_3.log
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --cores-per-task=24
#FLUX: --time-limit=5m
#FLUX: --gpus-per-task=4


echo "Loading required modules"
module load fosscuda/2020b
module load torchvision/0.10.0-python-3.8.6-pytorch-1.9.0

echo "Install libs" 
# pip3 install --upgrade pip
# pip3 install --user torch torchvision torchaudio
# pip3 install --user foolbox
# pip3 install --user git+https://github.com/fra31/auto-attack
# pip3 install --user scikit-learn
# pip3 install --user matplotlib

pip3 install statsmodels
# pip3 install -e .
pip3 install --user tqdm
pip3 install --user scikit-learn
pip3 install --user matplotlib

echo "Good to go!"
cd opacus/examples
python3 automator_3.py
# python3 -m torch.distributed.launch --nproc_per_node=4 automator_3.py

#!/bin/bash
#FLUX: --queue=windfall
#FLUX: --nodes=1
#FLUX: --cores=28
#FLUX: --gpus-per-node=1
#FLUX: --requires=os7
#FLUX: --bank=msurdeanu
#FLUX: --time-limit=48h

# The PBS parameters for memory (mem=168gb, pcmem=6gb) have no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.
# The PBS parameter to join stdout and stderr (-j oe) has no direct equivalent in flux-submit.


cd /xdisk/msurdeanu/mithunpaul/
module load cuda90/neuralnet/7/7.3.1.20
module load python/3.6/3.6.5

#uncomment this if you don't want to reinstall venv- usually you just have to do this only once ever
rm -rf sandeep_bert_venv
mkdir sandeep_bert_venv
python3 -m venv sandeep_bert_venv

#this is the only line you need if you already have a virtual_env set up
source sandeep_bert_venv/bin/activate

cd /xdisk/msurdeanu/mithunpaul/bert_tensorflow

pip install --upgrade pip
#pip install torch==1.5.0+cu92 torchvision==0.6.0+cu92 -f https://download.pytorch.org/whl/torch_stable.html
pip install -r requirements.txt




#####my code part
export PYTHONPATH="/home/u11/mithunpaul/sandeep_bert/"





bash run_sandeep_code.sh

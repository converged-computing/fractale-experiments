#!/bin/bash
# The -q windfall and -W group_list=msurdeanu directives are ignored as per instructions.
# The PBS select statement is translated to the following flux directives:
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=28
# The mem, pcmem, and os7 directives have no direct flux analog and are omitted.
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=48h
# The -j oe (join output/error) directive is the default behavior in Flux when no -o/-e are specified.


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

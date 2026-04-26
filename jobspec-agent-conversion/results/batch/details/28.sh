#!/bin/bash
#FLUX: --job-name=serene
#FLUX: --output=logs/serene.%J.out
#FLUX: --error=logs/serene.%J.err

#FLUX: --nodes=1
#FLUX: --time-limit=24h
# The --gres=gpu:4 and --gpus-per-node=4 directives are combined and translated to:
#FLUX: --gpus-per-node=4
# The --mail-type and --mail-user directives are ignored as per instructions.

module load python/3.8.6
module load cuda/10.1 
module load tensorflow/2.3.1

CONFIG_PATH="$HOME/SegU-Net/config"
#CONFIG_PATH="$HOME/data/outputs/16-06T13-25-30_128slice"
#CONFIG_PATH="$HOME/data/outputs/24-06T14-17-37_128slice"

source $HOME/nnevn/bin/activate
#python opt_talos.py $CONFIG_PATH/net_Unet_lc.ini
python segUNet.py $CONFIG_PATH/net_Unet_lc.ini

#python pred21cm.py $CONFIG_PATH/net2D_lc_full.ini
deactivate

#!/bin/sh
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=5
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=24h
#FLUX: --cwd=.

module load cuda/10.1
nvidia-smi

module load singularity

singularity exec --nv --bind wsolevaluation-master/:/mnt USandbox/ python /mnt/xquickruns_resnet50.py   --scoremap_root=xresearchlog/resnet50_deeplift_NBDT --NBDT 1  --scoremap_mode deeplift --scoremap_submode layer1 --ROOT_DIR wsolevaluation-master --debug_toggles 000000  


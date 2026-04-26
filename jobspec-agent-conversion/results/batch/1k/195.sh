#!/bin/sh
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: --time-limit=24h
#FLUX: --cwd=.


module load cuda/10.1
nvidia-smi

module load singularity


singularity exec --nv --bind wsolevaluation-master/:/mnt USandbox/ python /mnt/xquickruns_resnet50.py   --scoremap_root=xresearchlog/resnet50_gbp_NBDT --NBDT 1 --scoremap_mode gbp --scoremap_submode input --ROOT_DIR wsolevaluation-master --debug_toggles 000000  



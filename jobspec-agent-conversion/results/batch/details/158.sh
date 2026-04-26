#!/bin/bash
#FLUX: --job-name=solov2-tissuenet-n-2C
#FLUX: --time-limit=5d
#FLUX: --nodes=1
#FLUX: --gpus-per-node=4
#FLUX: --requires=a100
#FLUX: --output=solov2-tissuenet-n-2C.out
#FLUX: --error=solov2-tissuenet-n-2C.err

# The SLURM directive '--mem=200G' could not be translated.
# The script is assumed to run on a single node as no task count was specified.
# The task count will be determined by the 'dist_train.sh' script.

spack load cuda@11.0.2%gcc@9.3.0/lrd2rcw
cd mmdetection
nvidia-smi
sh mmdetection/tools/dist_train.sh mmdetection/configs/solov22C/solov2_r50_fpn_60e_coco_tissuenet_n.py 4 --work-dir /shared/rc/spl/mmdet_output/All_to_all/nuclear/SOLOv2

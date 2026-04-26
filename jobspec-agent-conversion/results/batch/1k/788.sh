#!/bin/bash
#FLUX: --job-name=swin-s-tissuenet-w-2C
#FLUX: --time-limit=72h
#FLUX: --error=%x_%j.err
#FLUX: --output=%x_%j.out
#FLUX: --gpus-per-node=4
#FLUX: --requires=a100

# The --mem=200G directive has no direct analog in the provided flux submit options.
# This will likely impact job scheduling and resource allocation.
# The --output and --error directives do not support Slurm-style substitutions (%x, %j).
# The -A (account) and -p (partition) directives were ignored as per instructions.

spack load cuda@11.0.2%gcc@9.3.0/lrd2rcw
cd mmdetection
nvidia-smi
sh mmdetection/tools/dist_train.sh mmdetection/configs/swin2C/mask_rcnn_swin-s-p4-w7_fpn_fp16_ms-crop-50e_coco_tissuenet_w.py 4 --work-dir /shared/rc/spl/mmdet_output/All_to_all/wholecell/Swin-S

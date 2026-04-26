#!/bin/bash
#FLUX: --job-name=msrcnn-livecell-1C
#FLUX: --time-limit=120h
#FLUX: --error=%x_%j.err
#FLUX: --output=%x_%j.out
#FLUX: --gpus-per-node=4
#FLUX: --requires=a100

# The --mem=200G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output and --error directives do not support Slurm-style job name/ID substitution (%x, %j).

spack load cuda@11.0.2%gcc@9.3.0/lrd2rcw
cd mmdetection
nvidia-smi
sh mmdetection/tools/dist_train.sh mmdetection/configs/ms_rcnn/ms_rcnn_r50_caffe_fpn_2x_coco_livecell.py 4 --work-dir /shared/rc/spl/mmdet_output/All_to_all/livecell/ms_rcnn_r50_caffe_fpn_1x_coco_livecell

#!/bin/bash
#FLUX: --job-name=solov2-tissuenet-n-2C
#FLUX: --bank=sada-cnmi
#FLUX: --queue=tier3
#FLUX: --time-limit=120h
#FLUX: --error={job_name}_{id}.err
#FLUX: --output={job_name}_{id}.out
#FLUX: --nodes=1
#FLUX: --gpus-per-node=4
#FLUX: --requires=a100

# The --mem=200G parameter from slurm has no direct equivalent in flux-submit.
# The job may fail due to insufficient memory.

spack load cuda@11.0.2%gcc@9.3.0/lrd2rcw
cd mmdetection
nvidia-smi
sh mmdetection/tools/dist_train.sh mmdetection/configs/solov22C/solov2_r50_fpn_60e_coco_tissuenet_n.py 4 --work-dir /shared/rc/spl/mmdet_output/All_to_all/nuclear/SOLOv2

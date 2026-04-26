#!/bin/bash
#FLUX: --time-limit=36h
#FLUX: --nodes=1
#FLUX: --cores=20
#FLUX: --gpus-per-node=2

echo "job starts"

module purge
module load gcc cmake
module load cuda/9.0.176 cudnn/7.1
source activate dlubu36
module list
unset LANG
export LANG=en_GB.UTF-8
cd /home/lxiaol9/videoText2018/flow-EAST/

python train_flow_based_video_object_detection_recurrent2.py 2>&1 | tee output_recurrent2.log

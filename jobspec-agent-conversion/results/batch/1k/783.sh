#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=24
#FLUX: --time-limit=10d
#FLUX: --gpus-per-task=1
#FLUX: --output=/home/gebreawe/Model_logs/Segmentation/ST-SPVNAS/logs/train_uda_nuscenes_kitti_T2_2_S0_0_time_._%j.log



# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

# module

cd ../..

ml torchsparse/1.4.0-foss-2021a-CUDA-11.3.1

python train_uda.py configs/data_config/da_kitti_nuscenes/uda_nuscenes_kitti_f1_0_time.yaml --distributed False --ssl False

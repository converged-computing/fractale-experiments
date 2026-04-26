#!/bin/bash
#FLUX: --ntasks=4
#FLUX: --gpus-per-task=1
#FLUX: --output=job.out
#FLUX: --error=job.err

#python ~/tensorflow/models/research/deeplab/model_test.py -p mlow
python ../train_data_aug.py
#python -m detectron2.utils.collect_env

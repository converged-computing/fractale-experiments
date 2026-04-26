#!/bin/bash

#FLUX: --job-name=MNIST-meanteach-50
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=12h
#FLUX: --output=scripts_logs/MNIST-meanteach-50.out
#FLUX: --error=scripts_logs/MNIST-meanteach-50.err

source /applis/environments/conda.sh
conda activate CGDetection

cd ~/code/CGvsNI-SSL/src
python ./main.py --train-test --data MNIST --nb_samples_train 50000 --nb_samples_test 10000 --nb_samples_labeled 50 --img_mode L --model CNN --method MeanTeacher --max_lr 0.0002 --epochs 300 --no-verbose

#!/bin/bash

#FLUX: --job-name=CGvsNI-testAutodesk-tempens
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=16h
#FLUX: --output=scripts_logs/CGvsNI-testAutodesk-tempens.out
#FLUX: --error=scripts_logs/CGvsNI-testAutodesk-tempens.err

source /applis/environments/conda.sh
conda activate CGDetection

cd ~/code/CGvsNI-SSL/src
python ./test_cgvsni.py --datasets_to_use Autodesk --label_mode Biclass --img_mode RGB --nb_samples_train 10080 --nb_samples_test 720 --nb_samples_labeled 1008 --max_lr 0.001 --method TemporalEnsembling --epochs 300 --no-verbose

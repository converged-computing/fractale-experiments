#!/bin/bash

#FLUX: --job-name=CGvsNI-testArtlantis-fullsup
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=16h
#FLUX: --output=scripts_logs/CGvsNI-testArtlantis-fullsup.out
#FLUX: --error=scripts_logs/CGvsNI-testArtlantis-fullsup.err

source /applis/environments/conda.sh
conda activate CGDetection

cd ~/code/CGvsNI-SSL/src
python ./test_cgvsni.py --datasets_to_use Artlantis --label_mode Biclass --img_mode RGB --nb_samples_train 10080 --nb_samples_test 720 --nb_samples_labeled 10080 --max_lr 0.001 --method FullSup --epochs 300 --no-verbose

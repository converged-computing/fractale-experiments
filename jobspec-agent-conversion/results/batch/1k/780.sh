#!/bin/sh
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --nodes=1
#FLUX: --time-limit=5h
#FLUX: --job-name="ai-detector-train"
#FLUX: --output=/zhome/ac/c/137651/joblogs/stdout_%J.out
#FLUX: --error=/zhome/ac/c/137651/joblogs/stderr_%J.out

echo "Starting job on GPU $CUDA_VISIBLE_DEVICES ..."

TPATH=/work3/s183911/dmiai
source /zhome/ac/c/137651/dmiai-setup.sh

python ai_text_detector/training/hf_loop.py\
    $TPATH\
    -c ai_text_detector/training/cv.ini
#    -c ai_text_detector/training/multisplits.ini



echo "Finished job !"

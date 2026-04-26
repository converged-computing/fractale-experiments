#!/bin/bash
#FLUX: --time-limit=12h
#FLUX: --gpus-per-node=2
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --job-name="Train th FRCNN Keras model with some POC data"


module load Python/3.6.4-foss-2018a
module load tensorflow/1.5.0-foss-2016a-Python-3.5.2-CUDA-9.1.85
module load OpenCV/3.1.0-foss-2016a-Python-3.5.1

cd /data/s3838730/ml/keras-frcnn
pip install tensorflow --user
pip install -r requirements.txt --user
python train_frcnn.py -p VOCdevkit --num_epochs 1000

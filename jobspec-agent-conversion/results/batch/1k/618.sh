#!/usr/bin/env sh
#FLUX: --job-name=script
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=6h
#FLUX: --cwd=/home/user/scratch/BridgeBidding/System

units=70
layers=3

module load apps/tensorflow/1.1.0/gpu

python main.py
#rm -r ~/scratch/BridgeBidding/EpisodeData/Train/$layers-$units


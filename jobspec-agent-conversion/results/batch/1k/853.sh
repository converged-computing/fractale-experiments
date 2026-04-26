#!/usr/bin/bash
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=2h

echo "output of the visible GPU environment"
nvidia-smi
module load python/miniforge-24.1.2 # python 3.10


# Use hackathon enviroment
source /project/dfreedman/hackathon/hackathon-env/bin/activate
echo Tensorflow
python MergeNeuralNetwork.py

#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --cores-per-task=6
#FLUX: --time-limit=3d
#FLUX: --output={id}.out

module load python/3.6
source tensorflow/bin/activate
python src/main.py ${scheme} -a ${algorithm} -l ${loss} -m ${model} -p problems/stp/puzzles_5x5_train/ --learn -d SlidingTile -b 7000 -g 10

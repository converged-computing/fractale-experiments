#!/bin/bash
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --gpus-per-task=1
#FLUX: --output=log/cnn_k562_classification_sampling.out
#FLUX: --error=log/cnn_k562_classification_sampling.err
#FLUX: --cc=1-10

eval $(spack load --sh miniconda3)
source activate active-learning

if [ -z ${FLUX_JOB_CC} ] ; then
    fold=1
else
    fold=${FLUX_JOB_CC}
fi

dirname=ModelFitting/K562/OneRound/${fold}
mkdir -p $dirname

python3 src/cnn_k562_classification_sampling.py $dirname --fold $fold --upper_bound --sampling_size 5000 3000 1000 --initial_data 5000
python3 src/cnn_k562_classification_sampling.py $dirname --fold $fold --sampling_size 5000 3000 1000 --initial_data 4000
python3 src/cnn_k562_classification_sampling.py $dirname --fold $fold --sampling_size 5000 3000 1000 --initial_data 3000

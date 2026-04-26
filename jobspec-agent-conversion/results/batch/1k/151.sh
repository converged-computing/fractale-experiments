#!/bin/bash
#FLUX: --job-name=Inat
#FLUX: --output=Inat.log
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=4
#FLUX: --cores-per-task=40


source activate py3.6pt1.5

python iNaturalTrain_reslt.py \
  --arch resnet50_reslt \
  --mark resnet50_reslt_bt256 \
  -dataset iNaturalist2018 \
  --data_path /research/dept6/jqcui/Data/iNaturalist2018/ \
  -b 256 \
  --epochs 200 \
  --num_works 40 \
  --lr 0.1 \
  --weight-decay 1e-4 \
  --beta 0.85 \
  --gamma 0.0 \
  --after_1x1conv \
  --num_classes 8142 \
  --evaluate \
  --resume data/iNaturalist2018/resnet50_reslt_bt256/model_best.pth.tar 

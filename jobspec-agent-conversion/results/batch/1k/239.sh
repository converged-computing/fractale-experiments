#!/bin/bash
#FLUX: --job-name=raven
#FLUX: --gpus-per-task=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=12
#FLUX: --nodes=1
#FLUX: --time-limit=0m

python raven/test.py \
    data.modality=audio \
    data/dataset=lrs3_trainval \
    experiment_name=asr_prelrs3vox2_base_ftlrs3trainval_test \
    model/visual_backbone=resnet_transformer_base \
    model.visual_backbone.ddim=256 \
    model.visual_backbone.dheads=4 \
    model.visual_backbone.dunits=2048 \
    model.visual_backbone.dlayers=6 \
    model.pretrained_model_path=ckpts/asr_prelrs3vox2_base_ftlrs3trainval.pth \


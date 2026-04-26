#!/bin/bash

#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --output=slogs/confusion-4-resnet-%j.out
#FLUX: --error=slogs/confusion-4-resnet-%j.err


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

module load cuda/9.1

SIGNS='["na","HAL","iš","MEŠ"]'
#SIGNS='["na","HAL"]'
#SIGNS='["na","HAL","iš","MEŠ","ma","1","du","da","AN","AŠ"]'


luigi --module deepscribe.pipeline.analysis RunAnalysisOnTestDataTask --local-scheduler \
      --imgfolder data/ochre/a_pfa \
      --hdffolder ../deepscribe-data/processed/pfa_new \
      --modelsfolder models \
      --target-size 50 \
      --keep-categories $SIGNS  \
      --fractions '[0.7, 0.1, 0.2]' \
      --model-definition data/model_defs/resnet50_blank_reweight.json

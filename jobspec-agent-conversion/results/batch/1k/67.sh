#!/bin/sh

#FLUX: --job-name=SIF_SC
#FLUX: --output=logs/gpu_SIF_slide_classification.out
#FLUX: --error=logs/gpu_SIF_slide_classification.err
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-task=1

echo "starting .."
# srun is not required for a single task job in Flux
# singularity exec /projets/sig/mullah/singularity/sif/ubuntu18_osirim.sif python3 "../programs/main.py" -extract TRUE -level 0 -size 224 -overlap FALSE
echo "done"

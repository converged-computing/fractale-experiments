#!/bin/bash --login
#FLUX: --job-name=z-keras-tuner
#FLUX: --cores=12
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1d


# NOTE: Memory, jobfs, and storage requests are not supported and have been omitted.


## Activate TensorFlow environment
module use /g/data/dk92/apps/Modules/modulefiles
module load NCI-ai-ml/22.11


# Run Keras tuner
# cd $PBS_O_WORKDIR # This is the default behavior in Flux
python3 keras-tuner.py > "tuner_$(date +"%Y_%m_%d_%H_%M").log" 2>&1


# Request interactive GPU
# qsub -I -q gpuvolta -lwd,walltime=1:00:00,ngpus=1,ncpus=12,mem=96GB,jobfs=1GB,storage=gdata/iu57+gdata/v88+gdata/dk92

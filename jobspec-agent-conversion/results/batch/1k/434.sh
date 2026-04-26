#!/bin/bash
#FLUX: --cores=4
#FLUX: --gpus-per-task=1
#FLUX: --output=./out/udacity_new_xml_test_train.out
#FLUX: --error=./out/udacity_new_xml_test_train.err
#FLUX: --job-name=udacity_new_xml_test_train

# The SLURM directive '--mem 30G' could not be translated.

nvidia-smi
export CUDA_LAUNCH_BLOCKING=1

LEARNING_RATE=1e-3
BATCH_SIZE=1
DECAY_STEP=5

python3 test_net.py --dataset pascal_voc --net res101 \
                       --cuda --mGPUs --checksession 1 --checkepoch 20 --checkpoint 2504

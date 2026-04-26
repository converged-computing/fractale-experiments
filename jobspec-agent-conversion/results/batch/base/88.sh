#!/bin/bash
#FLUX: --cores=4
#FLUX: -q mhigh
#FLUX: --gpus-per-node=1
#FLUX: --output=./out/{flux:jobname}_{flux:jobid}.out
#FLUX: --error=./out/{flux:jobname}_{flux:jobid}.err
#FLUX: --job-name=udacity_new_xml_test_train

# NOTE: The Slurm directive '--mem 30G' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
# NOTE: Flux does not support a list of queues, so only the first from the original list ('mhigh') is used.
# NOTE: The Slurm filename pattern for user name ('%u') was omitted from the output/error files.

nvidia-smi
export CUDA_LAUNCH_BLOCKING=1

LEARNING_RATE=1e-3
BATCH_SIZE=1
DECAY_STEP=5

python3 test_net.py --dataset pascal_voc --net res101 \
                       --cuda --mGPUs --checksession 1 --checkepoch 20 --checkpoint 2504


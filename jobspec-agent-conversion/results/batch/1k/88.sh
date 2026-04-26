#!/bin/bash
#FLUX: --job-name=pytorch
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=1d

# NOTE: The -j oe (join output/error) option is not supported.

# cd $PBS_O_WORKDIR; # This is the default behavior in Flux
np=$(cat ${PBS_NODEFILE} | wc -l);

image="/app1/common/singularity-img/3.0.0/pytorch_1.3_libsndfile_cuda10.0-cudnn7-devel-ubuntu18.04-py36.simg"

# NOTE: $PBS_JOBID has been replaced with $FLUX_JOB_ID
singularity exec $image bash << EOF > stdout.$FLUX_JOB_ID 2> stderr.$FLUX_JOB_ID

python train.py PETA --model resnet50--train_transform """{\"Order\": [\"Resize\", \"Pad\", \"RandomErase\", \"RandomCrop\",\"RandomHorizontalFlip\", \"ToTensor\", \"Normalize\"], \"Resize\": {\"size\": [256, 192]}, \"Pad\": {\"padding\": 10}, \"RandomCrop\": {\"size\": [256, 192]}, \"RandomHorizontalFlip\": {}, \"RandomErase\": {\"Wr\": [0.05, 0.3], \"Hr\": [0.05, 0.3]}, \"Normalize\": {\"mean\": [0.485, 0.456, 0.406], \"std\": [0.229, 0.224, 0.225]}}"""

# you can put more commands here
echo “PETA_resnet50_RandomErase_v1”

EOF

#!/bin/bash
#FLUX: --job-name=Cifar10-4node
#FLUX: --output=Cifar10-4node.out
#FLUX: --nodes=4
#FLUX: --ntasks=4
#FLUX: --time-limit=1h


export OMP_NUM_THREADS=64
export KMP_BLOCKTIME=0
export KMP_SETTINGS=1
export KMP_AFFINITY=granularity=fine,verbose,compact,1,0
module load phdf5

flux run -n 4 mkdir /tmp/keras
/home1/apps/dl-tools/bin/broadcast-mpi.sh /home1/apps/keras/data/datasets.tar /tmp/keras/datasets.tar 4
flux run -n 4 tar xf /tmp/keras/datasets.tar -C /tmp/keras

flux run -n 4 python cifar10_resnet_horovod.py


#!/bin/sh
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=6h
#FLUX: --output=results/log


source /home/he.1773/.bashrc
source activate confMILE
echo $CONDA_PREFIX
echo $FLUX_JOB_ID

GPUS=$(hostname)
GPUS=${GPUS//".cluster"/""}
echo $GPUS

module load cuda/11.8
nvidia-smi
which nvidia-smi

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/home/he.1773/miniconda3-23.9.0/envs/mg-nov/lib
for EPOCH in 200 500 1000
do
  for LAMBDA in 0.1 0.3 0.5 0.7 0.9 0.99
  do
    for LR in 0.02 0.01 0.005 0.001
    do
      python main.py --jobid ${FLUX_JOB_ID} --lambda-fl ${LAMBDA} --learning-rate ${LR} --epoch ${EPOCH}
    done
  done
done

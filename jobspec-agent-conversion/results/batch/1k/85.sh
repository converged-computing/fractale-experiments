#!/bin/sh
# Node resource configurations
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-node=4
#FLUX: --error=/scratch/user/OUTPUTS/logs/{id}.err
#FLUX: --output=/scratch/user/OUTPUTS/logs/{id}.out
#FLUX: --cc=0-1


# We want names of master node
MASTER=`/bin/hostname -s`
MPORT=$(shuf -i 6000-9999 -n 1)
echo "Master: $MASTER"
echo "Port: $MPORT"

jobdir="$(dirname "$(dirname "$(pwd)")")";

CONFIG=$1
DATASET=$2
WEIGHT=$3
WEIGHT_PATH=${WEIGHT}
SEED=${4:-42}

cd $jobdir;

python eval_finetune_ood.py \
            --dist-url tcp://${MASTER}:${MPORT} \
            --dist-backend 'nccl' \
            --multiprocessing-distributed \
            --world-size 1 --rank 0 \
            --quiet --sub_dir 'finetune' \
            --db ${DATASET} \
            --config-file ${CONFIG} \
            --weight_path ${WEIGHT_PATH} \
            --seed $SEED

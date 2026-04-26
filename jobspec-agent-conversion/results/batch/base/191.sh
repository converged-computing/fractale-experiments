#!/bin/bash
#FLUX: --job-name=br5_FPointNet
#FLUX: --queue=gpu
#FLUX: --nodes=1
#FLUX: --ntasks=32
#FLUX: --time-limit=3d
#FLUX: --output=/home/jbandl2s/train.{id}.out
#FLUX: --error=/home/jbandl2s/train.{id}.err

# The --mem=16G parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.

# The original script requested 0 GPUs, this is the default and is preserved.


# load cuda
module load cuda

# activate environment
source ~/anaconda3/bin/activate ~/anaconda3/envs/3DOD_Env

# locate to your root directory
cd /home/jbandl2s/sub_ensembles/models
# run the script
DATA_FILE="/scratch/jbandl2s/Lyft_dataset/artifacts/frustums_train"
MODEL_LOG_DIR="./log_v1_test/"
RESTORE_MODEL_PATH="./log_v1_test/model.ckpt"

# python train_v2.py --gpu 0 --model frustum_pointnets_v1 --log_dir $MODEL_LOG_DIR --max_epoch 200 --batch_size 32 --decay_step 800000 --decay_rate 0.5 --data_dir $DATA_FILE

python train_branch_15.py

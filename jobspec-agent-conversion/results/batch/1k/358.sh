#!/bin/bash
#
#FLUX: --job-name=bookcorpus-preprocess
#FLUX: --output=/ukp-storage-1/zhang/slurm_logs/bookcorpus-preprocess-%j.out
#FLUX: --ntasks=1
#FLUX: --cores-per-task=128
#FLUX: --gpus-per-task=1


source activate /mnt/beegfs/work/zhang/conda/dragon

module purge
module load cuda/11.0 # you can change the cuda version

nvidia-smi
nproc
free -h




# training
cd /ukp-storage-1/zhang/FinalThesis2023/
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/mnt/beegfs/work/zhang/conda/env/lib
export WANDB_CACHE_DIR=/ukp-storage-1/zhang/wandb/cache
export WANDB_CONFIG_DIR=/ukp-storage-1/zhang/wandb/config
export CUDA_VISIBLE_DEVICES=0
export NLTK_DATA='./nltk_data'

python3 -u preprocess.py -p 128 --run bookcorpus

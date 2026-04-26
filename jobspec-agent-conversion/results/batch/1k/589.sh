#!/bin/bash --login
#FLUX: --nodes=1
#FLUX: --job-name=LwFT1_5
#FLUX: --output=/path/to/output.out
#FLUX: --error=/path/to/error.err
#FLUX: --time-limit=50h
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=2
#FLUX: --cores-per-task=12
#FLUX: --cwd=../../..


# activate the conda environment
module purge
module load gcc/11.1.0
conda activate realtime_ocl

# run the application:
python main.py \
--dataset 'cloc' \
--batch_size 128 \
--lr 0.005 \
--lr_type 'constant' \
--batch_delay 1.5 \
--gradient_steps 1 \
--output_dir '/path/to/tensorboard/output' \
--workers 12 \
--method 'LwF' \
--LwF_warmup 0.05 \
--LwF_update_freq 1000 \
--seed 123 \
--dataset_root '/path/to/CLOC/release/' \
--size_replay_buffer 40000 \
--pretrained

#!/bin/bash --login
#FLUX: --nodes=1
#FLUX: --job-name=ACE
#FLUX: --output=/path/to/output.out
#FLUX: --error=/path/to/error.err
#FLUX: --time-limit=1h
#FLUX: --ntasks=1
#FLUX: --gpus-per-node=1
#FLUX: --requires=gpu
#FLUX: --cores-per-task=6


# activate the conda environment
module purge
module load gcc/11.1.0
conda activate realtime_ocl

# run the application:
cd ../../..
python main.py \
--dataset 'cifar100' \
--batch_size 10 \
--lr 0.001 \
--lr_type 'constant' \
--batch_delay 0 \
--gradient_steps 1 \
--output_dir '/path/to/tensorboard/output' \
--workers 4 \
--method 'ACE' \
--seed 123 \
--size_replay_buffer 100

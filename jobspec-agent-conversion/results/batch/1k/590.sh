#!/bin/bash --login
#FLUX: --nodes=1
#FLUX: --job-name=GSS_T5
#FLUX: --output=/path/to/output.%J.out
#FLUX: --error=/path/to/error.%J.err
#FLUX: --time-limit=1h
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=6


# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.

# activate the conda environment
module purge
module load gcc/11.1.0
conda activate realtime_ocl

# run the application:
cd ../../..
python main.py \
--dataset 'cifar100' \
--batch_size 10 \
--lr 0.005 \
--lr_type 'constant' \
--batch_delay 5 \
--gradient_steps 1 \
--output_dir '/path/to/tensorboard/output' \
--workers 4 \
--method 'GSS' \
--seed 123 \
--GSS_threshold 0.0 \
--GSS_mem_strength 10 \
--size_replay_buffer 100

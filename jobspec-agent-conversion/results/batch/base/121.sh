#!/bin/bash --login
#FLUX: --nodes=1
#FLUX: --queue=batch
#FLUX: --job-name=ACE
#FLUX: --output=/path/to/output.{id}.out
#FLUX: --error=/path/to/error.{id}.err
#FLUX: --time-limit=1h
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=6

# The --mem=200G parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.


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

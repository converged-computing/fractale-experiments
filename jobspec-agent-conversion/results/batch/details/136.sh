#!/bin/bash -l
#FLUX: --nodes=2
#FLUX: --time-limit=4h
#FLUX: --requires=gpu
#FLUX: --exclusive
#FLUX: --tasks-per-node=8
#FLUX: --cores-per-task=10
#FLUX: --gpus-per-task=1

module load pytorch/v1.4.0-gpu
module list
export HDF5_USE_FILE_LOCKING=FALSE

# The complex srun loop from the Slurm script is replaced by a single
# flux run command. This is a more standard and robust way to launch
# distributed jobs. Flux and the PyTorch distributed backend will handle
# the node communication setup automatically via environment variables.
echo "Starting distributed training with Flux..."
flux run python train.py --run_num=13

date

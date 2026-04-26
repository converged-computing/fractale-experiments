#!/bin/bash
#FLUX: --bank=project_2001659
#FLUX: --queue=gputest
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --cores-per-task=10
#FLUX: --time-limit=15m
#FLUX: --gpus-per-task=1
#FLUX: --requires=v100

# The SLURM --mem=0 directive has no direct Flux analog in the provided documentation.

module purge
module load pytorch

# srun is removed as Flux has already established the parallel environment for the 4 tasks.
# torchrun should detect the environment and manage its processes accordingly.

torchrun --standalone --nnodes=1 --nproc_per_node=4 mnist_ddp.py --epochs=100

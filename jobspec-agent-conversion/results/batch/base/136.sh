#!/bin/bash -l
#FLUX: --nodes=2
#FLUX: --time-limit=4h
#FLUX: --requires=gpu
#FLUX: --bank=m1759
#FLUX: --gpus-per-node=8
#FLUX: --exclusive
#FLUX: --cores=80

# NOTE: The original script requested 8 total GPUs but the launch command implied 8 GPUs PER NODE.
# This conversion follows the launch command's logic, requesting 16 total GPUs.

module load pytorch/v1.4.0-gpu
module list
export HDF5_USE_FILE_LOCKING=FALSE

# The master address is determined by the hostname of the rank-0 task in the allocation
export MASTER_ADDR=$(flux exec -r 0 hostname)

# The original script's manual loop over srun is replaced by a single flux run command.
# This command launches one process on each of the 2 nodes.
# Each of these processes then uses torch.distributed.launch to start 8 workers on its node.
# Note: --nnodes was corrected from 8 to 2.
flux run -n 2 -N 2 --tasks-per-node=1 python -m torch.distributed.launch \
    --nproc_per_node=8 \
    --nnodes=2 \
    --node_rank=$FLUX_NODE_RANKID \
    --master_addr=$MASTER_ADDR \
    train.py --run_num=13

date

#!/bin/bash -l
#FLUX: --nodes=1
#FLUX: --time-limit=20m
#FLUX: --job-name=mnist_1node_8gpus


#submisstion script for running pytorch_mnist with DDP

echo "Running Cobalt Job $FLUX_JOB_ID."

module load conda
conda activate


N_NODES=$(flux resource list | wc -l)
RANKS_PER_NODE=8
let N_RANKS=${RANKS_PER_NODE}*${N_NODES}

echo "Current Directory: "
pwd


# Here's the MPI Command, using a heredoc to encapsulate the venv setup:
flux run -n $N_RANKS --tasks-per-node=8 \
python pytorch_mnist.py --device gpu --epochs 32


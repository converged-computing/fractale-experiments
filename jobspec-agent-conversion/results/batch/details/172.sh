#!/bin/sh
#FLUX: --nodes=2
#FLUX: --requires=polaris
#FLUX: --time-limit=8h
#FLUX: --job-name=GNN_DDP_4

# The original script dynamically determined GPUs per node. We are assuming a fixed
# number of 4 GPUs per node, which is common for Polaris.
# This leads to 2 nodes * 4 GPUs/node = 8 total tasks, with 1 GPU per task.
#FLUX: --tasks-per-node=4
#FLUX: --gpus-per-task=1

# Change to working directory
# The $PBS_O_WORKDIR variable is not needed; Flux starts in the submission directory.

TSTAMP=$(date "+%Y-%m-%d-%H%M%S")
echo "Job started at: {$TSTAMP}"

# Load modules: 
source /lus/eagle/projects/datascience/sbarwey/codes/ml/pytorch_geometric/module_config

# The complex mpiexec command is replaced by a simpler flux run.
# Resource discovery is handled by the Flux directives above.

# run 
flux run \
	--verbose \
    -o cpu-affinity=off \
	./set_affinity_gpu_polaris.sh python3 main.py seed=65 use_noise=True topk_rf=4

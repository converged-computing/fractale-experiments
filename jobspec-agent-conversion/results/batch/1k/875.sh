#!/bin/sh
#FLUX: --nodes=1
#FLUX: --time-limit=1h
#FLUX: --job-name=bfs_postproc

# Change to working directory

TSTAMP=$(date "+%Y-%m-%d-%H%M%S")
echo "Job started at: {$TSTAMP}"


# Load modules: 
source /lus/eagle/projects/datascience/sbarwey/codes/ml/pytorch_geometric/module_config

# Get number of ranks 
NUM_NODES=$FLUX_JOB_SIZE

# Get number of GPUs per node
NGPUS_PER_NODE=$(nvidia-smi -L | wc -l)

# Get total number of GPUs 
NGPUS="$((${NUM_NODES}*${NGPUS_PER_NODE}))"

# Print 
echo $NUM_NODES $NGPUS_PER_NODE $NGPUS

# run 
python postprocess.py 

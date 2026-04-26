#!/bin/sh
#FLUX: --nodes=2
#FLUX: --requires=polaris
#FLUX: --time-limit=8h
#FLUX: --requires=filesystems:home:eagle
#FLUX: --queue=preemptable
#FLUX: --bank=datascience
#FLUX: --job-name=GNN_DDP_4


# Change to working directory is handled by Flux by default

TSTAMP=$(date "+%Y-%m-%d-%H%M%S")
echo "Job started at: {$TSTAMP}"


# Load modules: 
source /lus/eagle/projects/datascience/sbarwey/codes/ml/pytorch_geometric/module_config

# Get number of ranks
# The PBS_NODEFILE logic is replaced with the FLUX_JOB_NNODES environment variable 
NUM_NODES=${FLUX_JOB_NNODES}

# Get number of GPUs per node
NGPUS_PER_NODE=$(nvidia-smi -L | wc -l)

# Get total number of GPUs 
NGPUS="$((${NUM_NODES}*${NGPUS_PER_NODE}))"

# Print 
echo $NUM_NODES $NGPUS_PER_NODE $NGPUS

# The mpiexec command is replaced with flux run. 
# Flux automatically handles the host list and process distribution.
flux run \
	--verbose \
	-n $NGPUS \
	--tasks-per-node $NGPUS_PER_NODE \
    --cpu-bind=none \
	./set_affinity_gpu_polaris.sh python3 main.py seed=65 use_noise=True topk_rf=4 


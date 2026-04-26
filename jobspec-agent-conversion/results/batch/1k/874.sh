#!/bin/sh
#FLUX: --nodes=2
#FLUX: --time-limit=1h
#FLUX: --job-name=GNN_DDP_2

# NOTE: System, placement, and filesystem directives are not supported.

# Change to working directory
# cd ${PBS_O_WORKDIR} # This is the default behavior in Flux

TSTAMP=$(date "+%Y-%m-%d-%H%M%S")
echo "Job started at: {$TSTAMP}"


# Load modules: 
source /lus/eagle/projects/datascience/sbarwey/codes/ml/pytorch_geometric/module_config

# Get number of ranks 
NUM_NODES=$(flux resource list | wc -l)

# Get number of GPUs per node
NGPUS_PER_NODE=$(nvidia-smi -L | wc -l)

# Get total number of GPUs 
NGPUS="$((${NUM_NODES}*${NGPUS_PER_NODE}))"

# Print 
echo $NUM_NODES $NGPUS_PER_NODE $NGPUS

# run 
# mpiexec is replaced with 'flux run'
flux run -n $NGPUS -N $NGPUS_PER_NODE \
	./set_affinity_gpu_polaris.sh python3 main.py seed=65 use_noise=True topk_rf=8 

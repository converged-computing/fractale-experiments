#! /bin/bash
#FLUX: --bank=CSC249ADCD08

# NOTE: This script takes command-line arguments to configure its run.
# The number of nodes and tasks per node must also be set in the Flux directives below.
# Example: flux submit -N 4 --tasks-per-node=16 ./script.sh 4 16 2

# Read the number of nodes and ranks per node from arguments
nodes=$1
#FLUX: --nodes=$nodes
ranks_per_node=$2
#FLUX: --tasks-per-node=$ranks_per_node

# Load up the Python environment
module load miniconda-3/latest
source activate /lus/theta-fs0/projects/CSC249ADCD08/design/graph_sage/env
export PYTHONPATH=""  ## Get rid of the  default path from the modules


threads_per_core=$3
total_ranks=$((nodes * ranks_per_node))
threads_per_rank=$(((64 * threads_per_core) / ranks_per_node))

# Set config and run
#  - The aprun options -d (cores per task) and --cc (binding) do not have direct Flux equivalents.
#  - The cores-per-task will be implicitly set by the OMP_NUM_THREADS variable.
export KMP_BLOCKTIME=0
export KMP_AFFINITY="granularity=fine,compact,1,0"
export MPICH_GNI_FORK_MODE=FULLCOPY
export OMP_NUM_THREADS=$threads_per_rank

# The aprun command is replaced by flux run.
# Flux automatically determines the number of tasks and nodes from the allocation.
flux run --cores-per-task=$OMP_NUM_THREADS python profile_train.py ${@:4}

#! /bin/bash

# Load up the Python environment
module load miniconda-3/latest
source activate /lus/theta-fs0/projects/CSC249ADCD08/design/graph_sage/env
export PYTHONPATH=""  ## Get rid of the  default path from the modules

# Read the number of nodes and ranks per node
nodes=$1
ranks_per_node=$2
threads_per_core=$3
total_ranks=$((nodes * ranks_per_node))
threads_per_rank=$(((64 * threads_per_core) / ranks_per_node))

# Set config and run
#  - The Cobalt aprun command has been replaced with flux run.
#  - Note that resource directives are not included in this file as they
#    are determined by command-line arguments. They must be passed to `flux submit`.
export KMP_BLOCKTIME=0
export KMP_AFFINITY="granularity=fine,compact,1,0"
export MPICH_GNI_FORK_MODE=FULLCOPY
export OMP_NUM_THREADS=$threads_per_rank

flux run -n $total_ranks -N $ranks_per_node -c $OMP_NUM_THREADS python profile_train.py ${@:4}

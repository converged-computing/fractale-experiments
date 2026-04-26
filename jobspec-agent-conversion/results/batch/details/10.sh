#!/bin/bash
# The -q full-node (queue) and -A datascience (account) directives are ignored.
#FLUX: --nodes=1
#FLUX: --time-limit=4h
# The --attrs directive has no direct flux analog and is omitted.
# Necessary for Bash shells
. /etc/profile

# Tensorflow optimized for A100 with CUDA 11
module load conda/pytorch
# module load conda/pytorch

# Activate conda env
conda activate pycords
# conda activate base
export PYTHONPATH=/lus/grand/projects/datascience/ianwixom/expcifar:$PYTHONPATH

# User Configuration
# INIT_SCRIPT=$PWD/activate-dh.sh
COBALT_JOBSIZE=1
RANKS_PER_NODE=8

# Initialization of environment
# source $INIT_SCRIPT
module list

# The Cobalt mpirun command is replaced with `flux mini run`.
# The logic for calculating total tasks and tasks per node is preserved.
# Flux does not require a hostfile.
flux mini run -n $(( $COBALT_JOBSIZE * $RANKS_PER_NODE )) --tasks-per-node $RANKS_PER_NODE python cifar10cordsmodel.py

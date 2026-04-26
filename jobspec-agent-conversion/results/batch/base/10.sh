#!/bin/bash
#FLUX: --queue=full-node
#FLUX: --nodes=1
#FLUX: --tasks-per-node=8
#FLUX: --time-limit=4h
#FLUX: --bank=datascience
#FLUX: --requires=filesystems:home,grand,eagle,theta-fs0

# Necessary for Bash shells
. /etc/profile

# Tensorflow optimized for A100 with CUDA 11
module load conda/pytorch

# Activate conda env
conda activate pycords
export PYTHONPATH=/lus/grand/projects/datascience/ianwixom/expcifar:$PYTHONPATH

# Initialization of environment
module list

# The total number of tasks (8) and tasks per node (8) are now specified
# in the #FLUX directives above.
flux mini run -n 8 -N 8 python cifar10cordsmodel.py

#!/bin/bash
#FLUX: --time-limit=12h
#FLUX: --nodes=20

module load intelpython2

# The 'srun' command has been replaced by 'flux mini run' to launch the job's tasks.
# We assume the user intended to run one task per node (--nodes=20 -> -n 20).
flux mini run -n 20 python pca.py

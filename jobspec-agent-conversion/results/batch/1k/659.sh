#!/bin/bash
#FLUX: --time-limit=30m
#FLUX: --nodes=1
#FLUX: --cores=2
#FLUX: --gpus-per-node=1
#FLUX: --job-name=batch

# The PBS memory request (-l mem=8gb) has no direct analog in the provided flux options.
# This may impact job scheduling and resource allocation.
# The -A (account) directive was ignored as per instructions.
 
################################################################################

# NUMBA_CACHE_DIR will be set relative to the submission directory.
source ~/.bashrc
module load gcc/9.1.0
conda activate sdecouplings


SRAND=$RANDOM

python batch.py --adata /home/szhang99/st-schieb-1/sde_couplings/data_repr.h5ad --cellsets /home/szhang99/st-schieb-1/zsteve/reprogramming_batch/cell_sets.gmt --lamda 0.02 --outfile $SRAND.out --srand $SRAND

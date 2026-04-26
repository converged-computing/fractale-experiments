#!/bin/bash
#FLUX: --time-limit=30m
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --job-name=faces
 
################################################################################

export NUMBA_CACHE_DIR=$PBS_O_WORKDIR

source ~/.bashrc
module load gcc/9.1.0
conda activate sdecouplings
# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR

# NOTE: This script is a job array. The PBS_ARRAY_INDEX variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-10 ...'
SRAND=$FLUX_JOB_CC
python faces.py --srcpath /scratch/st-schieb-1/zsteve/wtf/src --n_iter 25 --outfile "output_$SRAND" --r 80 --srand $SRAND --tol 1e-4

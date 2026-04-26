#!/bin/bash
#FLUX: --time-limit=30m
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --job-name=faces
#FLUX: --cc=1-10

################################################################################

export NUMBA_CACHE_DIR=$PBS_O_WORKDIR

source ~/.bashrc
module load gcc/9.1.0
conda activate sdecouplings
cd $PBS_O_WORKDIR
SRAND=$FLUX_JOB_CC
python faces.py --srcpath /scratch/st-schieb-1/zsteve/wtf/src --n_iter 25 --outfile "output_$SRAND" --r 10 --srand $SRAND --mode nmf

#!/bin/bash
#FLUX: --ntasks=40
#FLUX: --time-limit=2h
#FLUX: --gpus-per-node=2


module load devel/cmake/3.18

module load devel/cuda/11.4
module load devel/cuda/11.4
module load compiler/gnu/12.1

cd /pfs/work7/workspace/scratch/cc7738-prefeature1
source /home/kit/aifb/cc7738/anaconda3/etc/profile.d/conda.sh
conda activate base
# conda activate EAsF 
conda activate subgraph_skeptch

#!/bin/bash
# Begin LSF Directives
#FLUX: --time-limit=12h
#FLUX: --nodes=22 
#FLUX: --job-name=QMhyperopt
#FLUX: --output=QMhyperopt.out
#FLUX: --error=QMhyperopt.err

module load python/3.6.6-anaconda3-5.3.0
module load gcc/4.8.5
cd /gpfs/alpine/med106/proj-shared/aclyde/summit/pytorch-1.0-p3/
source source_to_run_pytorch1.0-p3


cd     /gpfs/alpine/med106/proj-shared/aclyde/MolecularAttention
export TORCH_HOME=/gpfs/alpine/med106/proj-shared/aclyde/torch_cache/
flux run -n 132 -g 1 -c 7 python qm8_summit_tune.py


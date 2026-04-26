#!/bin/bash -l
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=256
#FLUX: --time-limit=2h30m
#FLUX: --cwd=hpmlt

module load env/staging/2022.1
module load Python/3.10.4-GCCcore-11.3.0
ml SciPy-bundle/2022.05-foss-2022a 
ml PyTorch/1.12.0-foss-2022a-CUDA-11.7.0
ml IPython/8.5.0-GCCcore-11.3.0

export OMP_NUM_THREADS=1

python __hpmlt__.py

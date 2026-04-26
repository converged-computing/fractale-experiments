#!/bin/bash
#FLUX: --output=log.job
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cwd=/home/cluebenchmark/lm-bff

module rm compiler/rocm/2.9
module load compiler/rocm/4.0.1

# load conda env
PYTHON_HOME=/public/home/cluebenchmark/anaconda3/envs/lm-bff
export PATH=$PYTHON_HOME/bin:$PATH
source ~/anaconda3/bin/activate
conda activate lm-bff

python test.py
#srun python test.py -n=1

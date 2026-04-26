#!/bin/bash
#FLUX: --job-name=federaser
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --output=tensor_out_8.txt
#FLUX: --error=tensor_error_8.txt


#module load gnu7/7.2.0
module load cuda/10.0.130
module load anaconda/3.6
#module load mvapich2
#module load pmix/1.2.3

source activate federaser

# The srun command is not necessary for a single-task job in Flux.
python ../Fed_Unlearn_main_8.py

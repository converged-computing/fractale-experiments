#!/bin/bash
#FLUX: --job-name=federaser
#FLUX: --nodes=1
# The --mem=50000 directive has no direct flux analog and is omitted.
#FLUX: --output=tensor_out_3.txt
#FLUX: --error=tensor_error_3.txt
# The --partition=gpu directive is ignored as per instructions.
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1

#module load gnu7/7.2.0
module load cuda/10.0.130
module load anaconda/3.6
#module load mvapich2
#module load pmix/1.2.3

source activate federaser

# The srun command is not needed for a single-process job in Flux.
python ../Fed_Unlearn_main_3.py

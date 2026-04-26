#!/bin/bash
#FLUX: --job-name=dsae168_6
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=15h
#FLUX: --gpus-per-task=2
#FLUX: --output=jo_ele_168_6.txt
#FLUX: --error=je_ele_168_6.txt

module load gcc/8.3.0 cuda/10.1.168
module load pytorch/1.3.0
module list


echo "Installing requirements ..."
pip install -r 'requirements.txt' --user -q --no-cache-dir
echo "Requirements installed."

echo "Start running ... "
# srun is not required for a single-task job in Flux
python3 single_gpu_trainer.py --data_name electricity --window 168 --horizon 6 --calendar False --batch_size 32 --split_train 0.7004694835680751 --split_validation 0.14929577464788732 --split_test 0.15023474178403756
echo "Finished running!"

# The seff command has no direct equivalent in Flux.
# You can get job information with 'flux job info $FLUX_JOB_ID'

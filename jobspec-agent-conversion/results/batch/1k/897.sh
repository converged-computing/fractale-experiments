#!/bin/bash
#FLUX: --job-name=dsap168_24
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=15h
#FLUX: --gpus-per-task=2
#FLUX: --output=jo_pow_168_24.txt
#FLUX: --error=je_pow_168_24.txt

module load gcc/8.3.0 cuda/10.1.168
module load pytorch/1.3.0
module list


echo "Installing requirements ..."
pip install -r 'requirements.txt' --user -q --no-cache-dir
echo "Requirements installed."

echo "Start running ... "
python3 single_gpu_trainer.py --data_name europe_power_system --window 168 --horizon 24 --powerset all --calendar False  --batch_size 32 --split_train 0.7004694835680751 --split_validation 0.14929577464788732 --split_test 0.15023474178403756
echo "Finished running!"

seff $FLUX_JOB_ID


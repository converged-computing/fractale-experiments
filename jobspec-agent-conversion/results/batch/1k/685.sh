#!/usr/bin/env zsh
#FLUX: --job-name=MSSM.py.job
#FLUX: --time-limit=48h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=11
#FLUX: --gpus-per-task=2
#FLUX: --output=/home/mf278754/master/output/out.out
#FLUX: --error=/home/mf278754/master/output/out.err

source /home/phys3b/Envs/keras_tf_sharedUsers/bin/activate

# The original script used a custom script to set CUDA_VISIBLE_DEVICES.
# This is not standard practice in Flux, which manages GPU visibility
# for the job automatically. The custom logic has been removed.
nvidia-smi

python /home/mf278754/master/Machine-Learning/training/train.py /home/mf278754/master/Machine-Learning/tasks/analysis/MSSM_HWW.yaml

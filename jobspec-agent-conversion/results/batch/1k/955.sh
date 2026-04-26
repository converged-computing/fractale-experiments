#!/bin/bash -l

#FLUX: --gpus-per-node=4
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=3d

echo STARTING AT $(date)

module purge
source /ssoft/spack/bin/slmodules.sh -s x86_E5v2_Mellanox_GPU
module load gcc cuda cudnn python mvapich2
source /home/amjakob/venvs/tensorflow-1.9/bin/activate


time python train_classification_tl.py --ckpt_load=keras_swisspv_untrained.h5 --epochs=200 --batch_size=100 --epochs_ckpt=5 --train_set=train.pickle --test_set=test.pickle --validation_split=0.1 --skip_train=False --skip_test=False --fine_tune_layers=4 --verbose=1

deactivate

echo FINISHED AT $(date)



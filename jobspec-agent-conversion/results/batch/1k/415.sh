#!/bin/sh
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-task=2
#FLUX: --time-limit=20h
#FLUX: --output=out_resnet50_0_60_new
#FLUX: --error=err_resnet50_0_60_new

# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR

module load pythonpackages/2.7.13/ucs4/gnu/447/keras/2.0.3/gnu
module load pythonpackages/2.7.13/ucs4/gnu/447/scikit-learn/0.18.1/gnu
module load pythonpackages/2.7.13/ucs4/gnu/447/opencv/3.2.0/gnu
module load pythonpackages/2.7.13/ucs4/gnu/447/pillow/4.1.0/gnu
module load pythonpackages/2.7.13/ucs4/gnu/447/h5py/2.7.0/gnu
module load pythonpackages/2.7.13/ucs4/gnu/447/matplotlib/2.0.0/gnu
module load apps/tensorflow/1.1.0/gpu
python /home/ee/mtech/eet162639/majorproject/transferlearning_hpc/resnet50_0_60.py

#!/bin/bash

# sbatch thefilename
# job standard output will go to the file slurm-%j.out (where %j is the job ID)

#FLUX: --time-limit=8h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=12
#FLUX: --gpus-per-node=2
#FLUX: --job-name="bmp_wa"

# The --partition and --mail directives were ignored as per instructions.

module load python/3.7.7-dwjowwi
python3 -c 'import tensorflow as tf; sess = tf.compat.v1.Session(config=tf.compat.v1.ConfigProto(log_device_placement=True))'
module load ml-gpu
export SM_FRAMEWORK=tf.keras;
ml-gpu python3 ~/bmp_wrr/cnn/model_wrr_wa_nolidar.py

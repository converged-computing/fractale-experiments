#! /bin/bash

#FLUX: --bank=QCL_PT
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --time-limit=24h
#FLUX: --queue=defaultQ

# The PBS memory request 'mem=30GB' has no direct Flux analog in the provided documentation.

module load cuda/10.0.130
module load openmpi-gcc/3.1.3

source miniconda/bin/activate training

cd models/

python research/object_detection/model_main_tf2.py --model_dir="/project/RDS-FSC-QCL_PT-RW/rcnn_model_data/" --num_train_steps=200000  --sample_1_of_n_eval_examples=1  --pipeline_config_path=pipeline.config  --alsologtostder

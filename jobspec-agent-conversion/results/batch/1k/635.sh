#!/bin/bash 
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --time-limit=1d
#FLUX: --gpus-per-task=1
#FLUX: --job-name=train_thermal
#FLUX: --output=train_thermal.out



eval "$(conda shell.bash hook)"
conda activate VTL

python3 train.py --dataset_name=satellite_0_thermalmapping_135 --mining=partial --datasets_folder=datasets --infer_batch_size 16 --train_batch_size 4 --lr 0.0001 --patience 100 --epochs_num 100 --use_faiss_gpu --conv_output_dim 4096 --add_bn --backbone resnet50conv4 --G_contrast

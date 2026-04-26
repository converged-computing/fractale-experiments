#!/bin/bash -l
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=12
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=30m
#FLUX: --output=dnn_single_node_1.txt


module load daint-gpu
module load PyTorch


which nvcc
nvidia-smi

which python



dnn="${dnn:-resnet20}"
#dnn="${dnn:-resnet50}"
echo $dnn
source exp_configs/$dnn.conf
nstepsupdate=1
flux mini run -n 1 python dl_trainer.py --dnn $dnn --dataset $dataset --max-epochs $max_epochs --batch-size $batch_size --data-dir $data_dir --lr $lr --nsteps-update $nstepsupdate

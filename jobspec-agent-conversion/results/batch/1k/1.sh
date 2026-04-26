#!/bin/bash
#FLUX: --nodes=1
#FLUX: --gpus-per-node=4
#FLUX: --time=3d
#FLUX: --ntasks=8


module purge
module load fosscuda/2019b
module load cuda/10.1.243
module load gcccore/8.3.0 
module load gcc/8.3.0 openmpi/3.1.4
module load python/3.7.4 
module load opencv
module load pillow
module load torch/20200428
module load scipy-bundle
module load pyyaml
module load numpy/1.17.3-python-3.7.4
module load torchvision
module load matplotlib/3.1.1-python-3.7.4
module load scikit-learn
module load torchvision/0.5.0-python-3.7.4
module load tqdm
module unload pytorch/1.4.0-python-3.7.4 
module load pytorch-geometric/1.6.1-python-3.7.4-pytorch-1.6.0
module load tensorflow/2.3.1-python-3.7.4

# The torch.distributed.launch command is replaced by 'flux run'
time flux run -n 4 python train.py --batch-size 32 --epochs 100 --data custom_train/dataset_nt.yaml --weights weights/yolov5l.pt --nosave

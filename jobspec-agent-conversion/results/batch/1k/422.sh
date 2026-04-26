#! /bin/bash
#FLUX: --job-name=CAMs_Attack2
#FLUX: --output=/home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/attack_logs/out.log
#FLUX: --error=/home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/attack_logs/err.log
#FLUX: --ntasks=1
#FLUX: --cores-per-task=100


rm -r /home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/attack_logs
mkdir /home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/attack_logs



source /apps/compilers/anaconda3/etc/profile.d/conda.sh
conda activate cv

python  /home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/attacks2.py --dataset imagenet --n_classes 100 --many_models True

#! /bin/bash
#FLUX: --job-name=CAMs_Attack
#FLUX: --output=/home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/logs/out.log
#FLUX: --error=/home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/logs/err.log
#FLUX: --cores=104


rm -r /home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/logs
mkdir /home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/logs



source /apps/compilers/anaconda3/etc/profile.d/conda.sh
conda activate cv

python  /home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/attacks.py --dataset imagenet --n_classes 100 --many_models True

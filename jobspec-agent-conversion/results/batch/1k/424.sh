#! /bin/bash
#FLUX: --job-name=MakingPlots
#FLUX: --output=/home/niranjan.rajesh_asp24/thesis-manifolds/plots/logs/out.log
#FLUX: --error=/home/niranjan.rajesh_asp24/thesis-manifolds/plots/logs/err.log
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10


rm -r /home/niranjan.rajesh_asp24/thesis-manifolds/plots/logs
mkdir /home/niranjan.rajesh_asp24/thesis-manifolds/plots/logs



source /apps/compilers/anaconda3/etc/profile.d/conda.sh
conda activate cv

python  /home/niranjan.rajesh_asp24/thesis-manifolds/resnet_exp/make_plots.py


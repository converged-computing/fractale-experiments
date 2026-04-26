#!/bin/bash

#FLUX: --time-limit=1d
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1


####################################################
##########MACHINE SPECIFIC DETAILS GO HERE##########
####################################################

module load anaconda3/2020.11
module load cuda/11.0
#conda activate /scratch/gwellawa/.conda/cgnet
conda activate prettyB
####################################################
########## FILESYSTEM DETAILS GO HERE ##############
####################################################


##################################################
######## SIMULATION DETAILS GO HERE ##############
#################################################

python /scratch/zyang43/ALP-Design/paper/random_search.py



#!/bin/bash
#FLUX: --nodes=1
#FLUX: --time-limit=2d6h
#FLUX: --ntasks=1



export MATLABPATH=$'/MouseMotionMapper/'
cd $MATLABPATH

TRAINDATA=/MouseMotionMapper/demo/trainingSet_new10.mat
SAVEPATH=/MouseMotionMapper/Kmeans/
module load matlab/R2013a
matlab -nosplash -nodesktop -nodisplay -singleCompThread -r "addpath(genpath('$MATLABPATH')); runCluster('101','$SAVEPATH','$TRAINDATA'); exit;"


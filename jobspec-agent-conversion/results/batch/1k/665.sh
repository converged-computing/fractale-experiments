#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=12
#FLUX: --gpus-per-node=4
#FLUX: --job-name=a_accre_train
#FLUX: --time-limit=5d
#FLUX: --output=/scratch/subravcr/trainedImagenet/myModels/xferLearning/a_accre_xfer_train_{id}.out

setpkgs -a matlab_r2016b
setpkgs -a gcc_compiler_4.9.3
setpkgs -a cuda7.5
setpkgs -a cudnn7.5-v5
setpkgs -a matlab_r2016b
echo "FLUX_JOB_ID: "$FLUX_JOB_ID

# test_flag[1=test, 0=real]
testMode=0

baseResultDir="/scratch/subravcr/trainedImagenet/myModels/xferLearning"
baseNetToUse="${baseResultDir}/net-epoch-10/base-net-epoch-10.mat"
echo "    testMode: "$testMode
echo "baseNetTouse: "$baseNetToUse

# bash a_accre_train.sh $FLUX_JOB_ID $testMode $baseNetToUse
bash a_accre_train.sh $FLUX_JOB_ID $testMode ${baseNetToUse}

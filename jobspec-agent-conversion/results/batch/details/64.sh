#!/bin/bash
#FLUX: --time-limit=72h
# The PBS select statement is translated to the following flux directives:
#FLUX: --nodes=1
#FLUX: --ntasks=24
#FLUX: --gpus-per-node=4
# The `powerai=on` constraint has no direct flux analog and is omitted.
# The -l place=scatter:excl directive is translated to --exclusive
#FLUX: --exclusive
#FLUX: --job-name=ResIm50E2
# The -j oe, -V, -q standard, and -A MHPCC96650NRL directives are ignored as per instructions.


. /usr/share/Modules/init/sh
module load glog/0.3.3
module load gflags/2.2.0

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/gpfs/pkgs/mhpcc/protobuf/lib:/gpfs/pkgs/mhpcc/boost/lib:/gpfs/pkgs/mhpcc/lmdb/lib:/gpfs/pkgs/mhpcc/leveldb/lib:/gpfs/pkgs/mhpcc/opencv-3.4.0/lib64

cd /gpfs/scratch/lnsmith/deepLearning/caffe/9-11-17/

./examples/bk_imagenet/queues/resnet/b2train2.sh

# CRITICAL: The qsub command is specific to PBS and will fail here.
# It must be replaced with `flux submit` for this script to work.
qsub ./examples/bk_imagenet/queues/resnet/maqsub1.pbs

exit
#module use $PROJECTS_HOME/datools/modulefiles
#module load anaconda/2
#module load caffe/5.0
#module list

#cd /gpfs/scratch/lnsmith/deepLearning/fewTrainingData/imagenet

#./examples/bk_imagenet/train.sh

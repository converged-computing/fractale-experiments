#!/bin/bash
#FLUX: --time-limit=72h
#FLUX: --nodes=1
#FLUX: --cores=24
#FLUX: --ntasks=24
#FLUX: --gpus-per-node=4
#FLUX: --requires=powerai
#FLUX: --exclusive
#FLUX: --job-name=ResIm50E2
#FLUX: --queue=standard
#FLUX: --bank=MHPCC96650NRL

# The PBS parameter '-j oe' to join stdout and stderr has no direct equivalent in flux-submit.
# The PBS parameter -V is the default behavior in Flux and is not needed.

. /usr/share/Modules/init/sh
module load glog/0.3.3
module load gflags/2.2.0

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/gpfs/pkgs/mhpcc/protobuf/lib:/gpfs/pkgs/mhpcc/boost/lib:/gpfs/pkgs/mhpcc/lmdb/lib:/gpfs/pkgs/mhpcc/leveldb/lib:/gpfs/pkgs/mhpcc/opencv-3.4.0/lib64

cd /gpfs/scratch/lnsmith/deepLearning/caffe/9-11-17/

./examples/bk_imagenet/queues/resnet/b2train2.sh

# The PBS command 'qsub' has been replaced with 'flux submit'.
# The submitted script 'maqsub1.pbs' must also be a valid job script for the Flux environment.
flux submit ./examples/bk_imagenet/queues/resnet/maqsub1.pbs

exit
#module use $PROJECTS_HOME/datools/modulefiles
#module load anaconda/2
#module load caffe/5.0
#module list

#cd /gpfs/scratch/lnsmith/deepLearning/fewTrainingData/imagenet

#./examples/bk_imagenet/train.sh

#!/bin/bash
#FLUX: -t 72h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=24
#FLUX: --gpus-per-node=4
#FLUX: --requires=powerai
#FLUX: --exclusive
#FLUX: --job-name=ResImOrig2
#FLUX: -q standard
#FLUX: -B MHPCC96650NRL

# NOTE: The PBS directive '-j oe' to join stdout/stderr was omitted as no output file was specified.
# To replicate this, set --output and --error to the same file path.
# NOTE: The PBS directive '-l place=scatter' was omitted as it has no direct Flux equivalent.
# NOTE: The PBS account directive '-A' has been mapped to the Flux bank directive '-B'.
# NOTE: The original script had an 'exit' command at the top, which has been moved to the end.

. /usr/share/Modules/init/sh
module load glog/0.3.3
module load gflags/2.2.0

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/gpfs/pkgs/mhpcc/protobuf/lib:/gpfs/pkgs/mhpcc/boost/lib:/gpfs/pkgs/mhpcc/lmdb/lib:/gpfs/pkgs/mhpcc/leveldb/lib:/gpfs/pkgs/mhpcc/opencv-3.4.0/lib64

cd /gpfs/scratch/lnsmith/deepLearning/caffe/9-11-17/

./examples/bk_imagenet/queues/resnet/atrain1.sh

# The 'qsub' command has been converted to 'flux submit'
flux submit ./examples/bk_imagenet/queues/resnet/aqsub1.pbs

exit
#module use $PROJECTS_HOME/datools/modulefiles
#module load anaconda/2
#module load caffe/5.0
#module list

#cd /gpfs/scratch/lnsmith/deepLearning/fewTrainingData/imagenet

#./examples/bk_imagenet/train.sh


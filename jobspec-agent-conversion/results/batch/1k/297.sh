#!/bin/bash
#FLUX: --time-limit=3d
#FLUX: --nodes=1
#FLUX: --tasks-per-node=24
#FLUX: --gpus-per-node=4
#FLUX: --exclusive
#FLUX: --job-name=ResImOrig2

# The following PBS directives could not be translated:
# -l select=...:powerai=on
# -j oe

# CRITICAL: The original script had an 'exit' command at the top,
# which would prevent any of the following commands from running.
# This has been preserved for accuracy, but likely needs to be removed.
exit

. /usr/share/Modules/init/sh
module load glog/0.3.3
module load gflags/2.2.0

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/gpfs/pkgs/mhpcc/protobuf/lib:/gpfs/pkgs/mhpcc/boost/lib:/gpfs/pkgs/mhpcc/lmdb/lib:/gpfs/pkgs/mhpcc/leveldb/lib:/gpfs/pkgs/mhpcc/opencv-3.4.0/lib64

cd /gpfs/scratch/lnsmith/deepLearning/caffe/9-11-17/

# The original script executed a shell script and then submitted another
# PBS job. This pattern is not directly translatable. The user should
# incorporate the logic from these scripts directly into this file.
# ./examples/bk_imagenet/queues/resnet/atrain1.sh
# qsub ./examples/bk_imagenet/queues/resnet/aqsub1.pbs

echo "This script is a non-functional template and requires manual editing."

#!/bin/bash
 
#FLUX: --nodes=1
#FLUX: --cores-per-task=8
#FLUX: --tasks-per-node=8
#FLUX: --gpus-per-node=8
#FLUX: --output=%x-%N-%j.out
#FLUX: --error=%x-%N-%j.err

# The --mem=128GB directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output and --error directives do not support Slurm-style job/node name/ID substitution.

source /etc/profile.d/modules.sh
module load rocm/5.3.0

tmp=/tmp/$USER/tmp-$$
mkdir -p $tmp

source /etc/profile.d/modules.sh
module load rocm/5.2.3
module load ompi/5.0.x
module load ucx/1.13.0

singularity run /shared/apps/bin/pytorch_rocm5.2.3_ubuntu20.04_py3.7_pytorch_1.12.1.sif python3 /var/lib/jenkins/pytorch-micro-benchmarking/micro_benchmarking_pytorch.py --network resnet50 --batch-size 512 --iterations 1000  --dataparallel --device_ids 0,1,2,3,4,5,6,7

rm -rf $tmp

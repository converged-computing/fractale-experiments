#!/bin/bash
#FLUX: --nodes=1
#FLUX: --time-limit=30m
#FLUX: --job-name=pytorch-bm-hsw
#FLUX: --output=logs/pytorch-bm-hsw-%J.out

set -e

# Options
version=v1.3.1
clean=false
backend=mpi
models="alexnet vgg11 resnet50 inceptionV3 lstm cnn3d"
if [ $# -ge 1 ]; then models=$@; fi

# Configuration
export OMP_NUM_THREADS=32
export KMP_AFFINITY="granularity=fine,compact,1,0"
export KMP_BLOCKTIME=1
# The SLURM_JOB_NUM_NODES variable was replaced with 1, matching the --nodes request.
export BENCHMARK_RESULTS_PATH=$SCRATCH/pytorch-benchmarks/hsw-$version-n1
if $clean; then
    [ -d $BENCHMARK_RESULTS_PATH ] && rm -rf $BENCHMARK_RESULTS_PATH
fi
module load pytorch/$version

# Run each model
for m in $models; do
    # srun is not needed for sequential tasks in a single-node Flux job.
    python train.py -d $backend configs/${m}.yaml
done

echo "Collecting benchmark results..."
python parse.py $BENCHMARK_RESULTS_PATH -o $BENCHMARK_RESULTS_PATH/results.txt

#!/bin/bash
#FLUX: --nodes=1
#FLUX: --time-limit=1h
#FLUX: --job-name=pytorch-bm-knl
#FLUX: --output=logs/pytorch-bm-knl.out

set -e

# Options
version=v1.3.1
clean=false
backend=mpi
models="alexnet vgg11 resnet50 inceptionV3 lstm cnn3d"
if [ $# -ge 1 ]; then models=$@; fi

# Configuration
export OMP_NUM_THREADS=68
export KMP_AFFINITY="granularity=fine,compact,1,0"
export KMP_BLOCKTIME=1
export BENCHMARK_RESULTS_PATH=$SCRATCH/pytorch-benchmarks/knl-$version-n${FLUX_JOB_NNODES}
if $clean; then
    [ -d $BENCHMARK_RESULTS_PATH ] && rm -rf $BENCHMARK_RESULTS_PATH
fi
module load pytorch/$version

# Run each model
for m in $models; do
    flux run -n 1 python train.py -d $backend configs/${m}.yaml
done

echo "Collecting benchmark results..."
python parse.py $BENCHMARK_RESULTS_PATH -o $BENCHMARK_RESULTS_PATH/results.txt

#!/bin/bash
#FLUX: --nodes=4
#FLUX: --time-limit=1h
#FLUX: --job-name=tensorflow_imagenet

echo "Running Cobalt Job $COBALT_JOBID."

#Loading modules
module load datascience/tensorflow-1.14

PROC_PER_NODE=1

# The aprun command has been replaced with flux run. Note that some
# aprun-specific affinity settings (-j, -d, -cc) do not have direct
# analogs and have been omitted.
export OMP_NUM_THREADS=8
export KMP_BLOCKTIME=0
export HOROVOD_TIMELINE=./timeline.json
export TIMELINE_MARK_CYCLES=1

flux run -n $(($COBALT_JOBSIZE*$PROC_PER_NODE)) -N $PROC_PER_NODE \
    python tensorflow_synthetic_benchmark.py --num_intra=8 --num_inter=2 --num-iters=10 --device cpu

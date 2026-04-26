#!/bin/bash
#FLUX: --nodes=4
#FLUX: --time-limit=1h
#FLUX: --queue=training
#FLUX: --requires="mcdram=cache&numa=quad"
#FLUX: --bank=SDL_Workshop
#FLUX: --job-name=tensorflow_imagenet

#submisstion script for running tensorflow_mnist with horovod

echo "Running Cobalt Job $FLUX_JOB_ID."

#Loading modules
module load datascience/tensorflow-1.14

# The aprun command has been replaced with 'flux mini run'.
# The total number of tasks (-n 4) and tasks per node (-N 1) are preserved.
# The aprun options for hyperthreading (-j 2) and binding (-cc depth) have no direct Flux analog.

# Set environment variables for the job
export OMP_NUM_THREADS=8
export KMP_BLOCKTIME=0
export HOROVOD_TIMELINE=./timeline.json
export TIMELINE_MARK_CYCLES=1

flux mini run -n 4 -N 1 \
    python tensorflow_synthetic_benchmark.py --num_intra=8 --num_inter=2 --num-iters=10 --device cpu

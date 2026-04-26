#!/bin/bash
#FLUX: --job-name=TestGPUOnSaga
#FLUX: --time-limit=5m
# The --mem-per-cpu=4G directive has no direct flux analog and is omitted.
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1

## Set up job environment:
set -o errexit  # Exit the script on any error
set -o nounset  # Treat any unset variables as an error

module --quiet purge  # Reset the modules to the system default
module load TensorFlow/2.6.0-foss-2021a-CUDA-11.3.1
module list

# Setup monitoring
nvidia-smi --query-gpu=timestamp,utilization.gpu,utilization.memory \
	--format=csv --loop=1 > "gpu_util-$FLUX_JOB_ID.csv" &
NVIDIA_MONITOR_PID=$!  # Capture PID of monitoring process
# Run our computation
python gpu_intro.py
# After computation stop monitoring
kill -SIGINT "$NVIDIA_MONITOR_PID"

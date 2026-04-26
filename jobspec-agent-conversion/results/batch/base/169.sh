#!/bin/bash
#FLUX: --job-name=TestGPUOnSaga
#FLUX: --bank=nn<XXXX>k
#FLUX: --time-limit=5m
#FLUX: --queue=accel
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1

# The SLURM directive '#SBATCH --mem-per-cpu=4G' has no direct equivalent in the provided flux submit options.
# This may result in the job using default memory allocation, potentially affecting performance or causing failure if it exceeds limits.
# The SLURM directive '#SBATCH --qos=devel' has no direct equivalent and has been omitted.

## Set up job environment:
set -o errexit  # Exit the script on any error
set -o nounset  # Treat any unset variables as an error

module --quiet purge  # Reset the modules to the system default
module load TensorFlow/2.6.0-foss-2021a-CUDA-11.3.1
module list

# Setup monitoring
# The SLURM_JOB_ID variable has been replaced with FLUX_JOB_ID
nvidia-smi --query-gpu=timestamp,utilization.gpu,utilization.memory \
	--format=csv --loop=1 > "gpu_util-${FLUX_JOB_ID}.csv" &
NVIDIA_MONITOR_PID=$!  # Capture PID of monitoring process

# Run our computation
# Using 'flux run' is the recommended way to launch tasks under Flux
flux run -n 1 python gpu_intro.py

# After computation stop monitoring
kill -SIGINT "$NVIDIA_MONITOR_PID"

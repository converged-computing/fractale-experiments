#!/bin/bash

#FLUX: --gpus-per-task=2
#FLUX: --job-name=ExampleJob
#FLUX: --ntasks=1
#FLUX: --cores-per-task=3
#FLUX: --time-limit=1h
#FLUX: --output=slurm_output_%A.out

# NOTE: The %A format specifier is not supported in Flux; files will be overwritten.

module purge
module load 2019
module load Python/3.7.5-foss-2019b
module load CUDA/10.1.243
module load cuDNN/7.6.5.32-CUDA-10.1.243
module load NCCL/2.5.6-CUDA-10.1.243
module load Anaconda3/2018.12

# Your job starts in the directory where you call sbatch
# Activate your environment
source activate mmalb

# NOTE: $TMPDIR is not available in Flux. A generic temporary path is used instead.
# You may need to change this to a specific scratch filesystem.
TMP_DIR="/tmp/${FLUX_JOB_ID:-$USER-temp}"
mkdir -p "$TMP_DIR"

cp -r $HOME/mmdetection/data "$TMP_DIR"
cp -r $HOME/mmdetection/configs "$TMP_DIR"
cd "$TMP_DIR"
pwd
ls

CONFIG=$1

PYTHONPATH="$(dirname $0)/..":$PYTHONPATH \
# srun and --launcher flag are removed
python -u $HOME/mmdetection/tools/train.py $CONFIG ${@:2}

cp -r work_dirs/cascade_df2 $HOME/mmdetection/scratch_output

# Clean up the temporary directory
rm -rf "$TMP_DIR"

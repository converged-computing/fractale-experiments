#!/bin/bash
#FLUX: --job-name=all_to_all_32
#FLUX: --error=all_to_all_32.{id}.err
#FLUX: --output=all_to_all_32.{id}.out
#FLUX: --nodes=32
#FLUX: --ntasks=32
#FLUX: --cores-per-task=40
#FLUX: --gpus-per-task=4
#FLUX: --time-limit=15m

module load gcc
module load cuda/10.2.89
module load hwloc

cd /g/g14/bienz1/BenchPress/spectrum_build/examples

nvidia-cuda-mps-control -d

flux mini run ./time_alltoall

echo quit | nvidia-cuda-mps-control

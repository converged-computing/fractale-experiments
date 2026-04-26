#!/bin/bash
#FLUX: --nodes=1
#FLUX: --tasks-per-node=2
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-task=1
#FLUX: -o cpu-affinity=per-task
 
module purge
module load gnu7/7.3.0
module load nvidia/cuda/10.1
source /home/p00lcy01/local/gcc7/openmpi-4.0.4/env.sh

/home/p00lcy01/VASP/b_gcc_mkl/bin/vasp_gpu
echo "== Wall time: ${SECONDS} secs"

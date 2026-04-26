#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=2
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-node=2

# The gres=gpu:2 directive is interpreted as 2 GPUs for the entire job.
# For a single node job, this is equivalent to --gpus-per-node=2.
# And with two tasks, this implies 1 GPU per task.
 
module purge
module load gnu7/7.3.0
module load nvidia/cuda/10.1
source /home/p00lcy01/local/gcc7/openmpi-4.0.4/env.sh

# The Slurm srun command has been replaced with the Flux equivalent.
# The --cpu_bind=v option has no direct analog in flux run.
flux run -n 2 /home/p00lcy01/VASP/b_gcc_mkl/bin/vasp_gpu
echo "== Wall time: ${SECONDS} secs"

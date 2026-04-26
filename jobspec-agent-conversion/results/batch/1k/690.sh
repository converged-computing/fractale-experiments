#!/bin/bash
# runmnist_array.sbatch
#
#FLUX: --job-name=runmnist
#FLUX: --time-limit=4h
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --output=outfiles/slurm.out # STDOUT
#FLUX: --error=outfiles/slurm.err # STDERR

module load Anaconda3/5.0.1-fasrc01
module load cuda/9.0-fasrc02 cudnn/7.4.1.5_cuda9.0-fasrc01

source activate tf1.12_cuda9

source sweeps/mnist_sweep/array_commands/${FLUX_JOB_CC}.sh


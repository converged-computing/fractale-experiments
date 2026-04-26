#!/bin/bash
#FLUX: --job-name=lmp_bench
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --time-limit=20m
#FLUX: --exclusive


module load lammps/8Feb2023-gcc8-impi-cuda118

export OMP_NUM_THREADS=1

# Change --gres=gpu:X above as well
flux run -n 10 --cpus-per-task=1 lmp -pk gpu 1 -sf gpu -in in.ethanol -l log.out_${FLUX_TASKS_PER_NODE}

#PARAMS="--ntasks=20 --hint=nomultithread --cpus-per-task=1"
#srun ${PARAMS} lmp -pk gpu 2 -sf gpu -in in.ethanol -l log.out_${SLURM_TASKS_PER_NODE}

#PARAMS="--ntasks=40 --hint=nomultithread --cpus-per-task=1"
#srun ${PARAMS} lmp -pk gpu 4 -sf gpu -in in.ethanol -l log.out_${SLURM_TASKS_PER_NODE}


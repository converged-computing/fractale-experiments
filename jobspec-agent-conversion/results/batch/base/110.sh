#!/bin/bash
#FLUX: --time-limit=1h30m
#FLUX: --nodes=3
#FLUX: --tasks-per-node=4
#FLUX: --gpus-per-node=4
#FLUX: --cores-per-task=4

# The SLURM directive '--ntasks-per-socket=2' has no direct equivalent in the provided flux submit options and has been omitted.
# This may affect performance if the application is sensitive to task placement on sockets.
# The SLURM directive '--mem-per-cpu=0' (request all memory) has no direct equivalent and has been omitted.
# The job will use the system's default memory allocation.

export PYTHONHASHSEED=0
module load anaconda
source activate pppl
module load cudatoolkit/8.0
module load cudnn/cuda-8.0/6.0
module load openmpi/cuda-8.0/intel-17.0/2.1.0/64
module load intel/17.0/64/17.0.4.196 intel-mkl/2017.3/4/64

#remove checkpoints for a benchmark run
rm /tigress/$USER/model_checkpoints/*
rm /tigress/$USER/results/*
rm /tigress/$USER/csv_logs/*
rm /tigress/$USER/Graph/*
rm /tigress/$USER/normalization/*

export OMPI_MCA_btl="tcp,self,sm"

# The 'srun' command is replaced with 'flux run'.
# Flux will launch the total number of tasks (nodes * tasks-per-node = 12) by default.
flux run python mpi_learn.py

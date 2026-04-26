#!/bin/bash
#FLUX: --time-limit=1h30m
#FLUX: --nodes=3
#FLUX: --tasks-per-node=4
#FLUX: --gpus-per-node=4
#FLUX: --cores-per-task=4

# The following SLURM directives could not be translated:
# --mem-per-cpu=0
# --ntasks-per-socket=2

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

# The 'srun' command has been replaced with 'flux run'.
flux run python mpi_learn.py

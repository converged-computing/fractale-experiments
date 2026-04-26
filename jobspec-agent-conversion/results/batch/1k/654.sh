#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --gpus-per-task=1
#FLUX: --time=2d
#FLUX: --job-name=hyper_job
#FLUX: --output=/scratch/jc11431/slurm_logs/slurm_%A_%a.out


# NOTE: The %A and %a format specifiers are not supported in Flux; files will be overwritten.

## First we ensure a clean environment by purging the current one
module purge

## Load Anaconda
module load anaconda3/2020.07
source ~/.bashrc
conda activate alignment

## Just log environment stats for diagnostics
myquota
nvidia-smi
which python
wandb login

## Run experiment
cd $HOME/git/few-shot-pretraining

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-10 ...'
echo FLUX_JOB_CC $FLUX_JOB_CC
wandb agent --count 1 junshern/alignment_pretraining/xnbj3wob

#!/bin/bash
#FLUX: --job-name=main
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --time-limit=14d
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=8



# salloc --ntasks=1 --partition=interactive --time=60  --mem=12GB --gpus=1 --nodelist=abacus001 --cpus-per-task=8

module load Miniconda3/4.9.2
# if ! (conda env list | grep ".venv2") ; then 
# 	conda create --name .venv2 python=3.7 -y
# fi
module load CUDA/10.2.89-GCC-8.3.0 # for CPAB
source activate .venv

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-384 ...'
CASE_NUM=`printf %03d $FLUX_JOB_CC`

cd runs
# srun is not required for a single-task job in Flux
bash run$CASE_NUM.sh

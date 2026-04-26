#!/bin/bash
#FLUX: --job-name=quoridor
#FLUX: --output=slurm.out
#FLUX: --error=slurm.err
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --cc=0
#FLUX: --time-limit=24h1m

echo "My FLUX_JOB_ID is $FLUX_JOB_ID."
echo "My FLUX_JOB_CC is $FLUX_JOB_CC"
echo "Executing on the machine:" $(hostname)

module load anaconda3/2021.5
conda activate torch-cpu


python train.py


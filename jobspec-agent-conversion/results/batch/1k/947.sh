#!/bin/bash 
#FLUX: -N 3
#FLUX: --tasks-per-node=40
#FLUX: -t 18h
#FLUX: --job-name=drip-model-grl-2023
#FLUX: --output=output_%j.txt

# The 'cd $SLURM_SUBMIT_DIR' line was removed as Flux jobs typically start in the submission directory by default.
 
module load NiaEnv/2019b
module load gcc/8.3.0 
module load boost/1.70.0 
module load openmpi/4.0.1 
module load dealii/9.2.0 
module load cmake/3.17.3

tag=v0

# Translated from SLURM's $SLURM_ARRAY_TASK_ID to Flux's $FLUX_JOB_CC
if [[ $FLUX_JOB_CC ]]
then
  id=$FLUX_JOB_CC
  tag=v${id%?}.${id: -1}
else
  tag=v0
fi

echo tag 

./run-tag $tag $HOME/aspect/build/aspect

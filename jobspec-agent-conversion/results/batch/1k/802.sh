#! /bin/bash
#FLUX: --time-limit=30m
#FLUX: --job-name=nn_boulder
#FLUX: --output=./out/nn_boulder%a.out
#FLUX: --error=./err/nn_boulder%a.err
#FLUX: --cc=10,20,30,40,50,60,70,80,90,100

# The --mem=2000 directive has no direct analog in the provided flux submit options.
# The --output and --error directives do not support Slurm-style array ID substitution (%a).
# All jobs in the collection will write to the same files.

export GHZHANG17_TASK_ID=$FLUX_JOB_CC
export GHZHANG17_JOB_ID=$FLUX_JOB_ID

echo "Task ID:" $GHZHANG17_TASK_ID
echo "Job ID:" $GHZHANG17_JOB_ID

module load python/3.6.3-fasrc01
module load Anaconda3/5.0.1-fasrc02
source activate comet
python nn_sgd.py --it_ind 0 --inputSize 100 --outputSize 100 --hiddenSize $GHZHANG17_TASK_ID --learningRate 5 --epochs 100000

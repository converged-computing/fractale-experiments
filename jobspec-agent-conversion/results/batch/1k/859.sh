#!/usr/local_rwth/bin/zsh

### COMMANDS to remember:
#  - shh login:     ssh -l ppxxxxxx login18-g-1.hpc.itc.rwth-aachen.de
#  - submit job:    sbatch <script>.sh
#  - list jobs:     sacct
#  - list gpu's:    nvidia-smi



### CONFIGURATION


# job name
#FLUX: --job-name=RubiksDL2


# GPU
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1

# max runing time
#FLUX: --time-limit=1d


### SCRIPT TO RUN

# change to the work directory
export PATH=$PATH:~/.local/bin
# load python
module load python/3.6.0

# enter git repo folder
cd ~/Rubiks-Cube-DL/

# run file through pipenv
# (makes sure dependencies are all there)
# NOTE: $SLURM_JOBID has been replaced with $FLUX_JOB_ID
pipenv run python train.py --ini ini/cube2x2-zero-goal-d30.ini -n run_${FLUX_JOB_ID}

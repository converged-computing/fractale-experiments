#!/bin/bash

#FLUX: --job-name=t-emf-l
#FLUX: --output=log_train_emf_lhc_{id}.log
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --time-limit=7d

# The --mem=32GB parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.
# The slurm output pattern '%a' for the array task ID has no equivalent.
# All array tasks will write to the same output file, which will corrupt the log.
# This script is intended as a job array. You MUST submit it with a range, e.g., 'flux submit --cc=0-9 ...'


# #SBATCH --gres=gpu:1 was commented out in the original script and is ignored here.

# module load cuda/10.1.105
source activate ml
export OMP_NUM_THREADS=1
cd /scratch/jb6504/manifold-flow/experiments

# The SLURM_ARRAY_TASK_ID variable is replaced by FLUX_JOB_CC
python -u train.py -c configs/train_mf_lhc_june.config --algorithm emf -i ${FLUX_JOB_CC}

#!/bin/bash
#FLUX: --time-limit=12h
#FLUX: --cores-per-task=1
#FLUX: --ntasks=1
#FLUX: --output=./results/slurm-{id}_$FLUX_JOB_CC.out

# The SLURM --mem directive has no direct Flux analog in the provided documentation.
# The SLURM --gres=gpu:k20:0 directive is handled by not requesting any GPUs.

module load imkl/2018.3.222
module load openmpi/3.1.2
module load cuda/10.0.130
module load python/3.7
source /project/cq-training-1/project1/teams/team06/ift6759-env/bin/activate
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/cvmfs/soft.computecanada.ca/easybuild/software/2017/avx2/Compiler/intel2016.4/cuda/10.0.130/extras/CUPTI/lib64
python evaluator.py predictions.txt data/admin_cfg.json -u data/user_cfg.json

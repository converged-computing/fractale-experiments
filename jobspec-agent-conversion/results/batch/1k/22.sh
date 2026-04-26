#!/bin/bash
#FLUX: --job-name=f_i
#FLUX: --output=local_logs/f_i.out 
#FLUX: --error=local_logs/f_i.err 
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=10
#FLUX: --time-limit=15h


# NOTE: --constraint=a100 and --hint=nomultithread are not supported.


module load cpuarch/amd
module load pytorch-gpu/py3/2.0.1
export PYTHONUSERBASE=$WORK/.local_flacon
export GIT_PYTHON_REFRESH=quiet

args=()

for seed in 42 43 44 45 46
do 
    args+=("--seed ${seed}")
done

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=0-4 ...'
python train_and_generate_and_eval.py --lr=3e-5 --rank=32 --train_data_dir=data/lm_data/txt_data/interferencev2 --eval_data_json=data/lm_data/interference.json --eval_split=test ${args[${FLUX_JOB_CC}]}

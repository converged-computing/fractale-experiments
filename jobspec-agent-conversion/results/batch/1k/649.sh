#!/bin/bash
#FLUX: --cpus-per-task=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --gres=gpu:1
#FLUX: --output=slurm%A_%a.out
#FLUX: --time=2d



# NOTE: The %A and %a format specifiers are not supported in Flux; files will be overwritten.
# NOTE: The --nodelist and --mem flags are not supported.


module load gpu/cuda/10.2 common/compilers/gcc/8.3.1

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-200 ...'
python3 ~/nasze-ca/src/prot-gen.py ${FLUX_JOB_CC}

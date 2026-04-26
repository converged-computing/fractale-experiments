#!/bin/bash
#FLUX: --job-name=itrust-linear_svc
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --cc=31
#FLUX: --time-limit=7d
#FLUX: --output=outputs/linear_svc-{id}.out
#FLUX: --error=errors/linear_svc-{id}.err

source ../.experiments_env/bin/activate

python linear_svc.py ${FLUX_JOB_CC} context_ONLY-ACTION-SPREAD20_K3_H4_P12

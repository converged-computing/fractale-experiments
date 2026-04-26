#!/bin/bash
#FLUX: --job-name=itrust-random_forest
#FLUX: --ntasks=1
#FLUX: --cores-per-task=2
#FLUX: --cc=28,30,31,32,34,36
#FLUX: --time-limit=7d
#FLUX: --output=outputs/random_forest-{id}.out
#FLUX: --error=errors/random_forest-{id}.err

source ../../.experiments_env/bin/activate

python random_forest.py ${FLUX_JOB_CC} context_SPREAD60_K3_H4_P12-BINARY no-personality

#!/bin/bash
##PBS -N GPM_$1          # job name
#FLUX: --job-name=GPM_$1
#FLUX: -B GT-rbras6-CODA20
#FLUX: --nodes=1
#FLUX: --cores=15
#FLUX: -t 30m

# NOTE: The PBS directive 'mem=20gb' was omitted as there is no direct Flux equivalent.
# This may cause the job to fail if scheduled on a node with insufficient memory.
# NOTE: The PBS directive '-j oe' to join output/error streams was omitted as there is no direct Flux equivalent.
# NOTE: The PBS directives for email notification ('-m', '-M') were omitted as there are no direct Flux equivalents.

/bin/echo Running on host: `hostname`.
/bin/echo In directory: `pwd`
/bin/echo Starting on: `date`

source activate ~/venvs/pydask

/bin/echo Parition $1

python /storage/coda1/p-rbras6/0/njadidoleslam3/projects/stochsm/model_simulations/postprocess/create_unified_data.py $1

#!/bin/bash
# The job name is parameterized by the first argument to the script.
#FLUX: --job-name=GPM_$1
# The -A (account) directive is ignored.
# The PBS resource request is translated to the following flux directives:
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=15
# The mem=20gb directive has no direct flux analog and is omitted.
#FLUX: --time-limit=30m
# The -j oe (join output/error) directive is the default behavior in Flux when no -o/-e are specified.
# The mail directives are commented out and ignored.

/bin/echo Running on host: `hostname`.
/bin/echo In directory: `pwd`
/bin/echo Starting on: `date`

source activate ~/venvs/pydask

/bin/echo Parition $1

python /storage/coda1/p-rbras6/0/njadidoleslam3/projects/stochsm/model_simulations/postprocess/create_unified_data.py $1

#!/bin/bash -l

#FLUX: --job-name=MURbui
# The -A (account) and -q (queue) directives are ignored.
# The PBS select statement is translated to the following flux directives:
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
# The mem=50GB directive has no direct flux analog and is omitted.
#FLUX: --gpus-per-task=1
# The gpu_type=a100 directive was commented out but is translated to a requirement.
#FLUX: --requires=a100
#FLUX: --time-limit=10m
#FLUX: --error=build.err
#FLUX: --output=build.out

module purge
module load ncarenv/22.12
module load nvhpc/22.11
module load cuda
module load craype
module load cray-mpich
module load ncarcompilers
module load cray-libsci
module list

make clean
make

#!/bin/bash
#FLUX: --job-name="glotzerlab-software build"
#FLUX: --bank=dmr140129
#FLUX: --queue=shared
#FLUX: --ntasks=1
#FLUX: --cores-per-task=32
#FLUX: --time-limit=8h

export OUTPUT_FOLDER=$PROJECT/software/conda
unset CMAKE_PREFIX_PATH

# Load modules used to build packages with native MPI support (no CUDA).
module reset
module load gcc/11.2.0 openmpi/4.1.6

export CC=$GCC_HOME/bin/gcc
export CXX=$GCC_HOME/bin/g++

./build.sh "$@" \
    --skip-existing \
    --variants "{'cluster': ['anvil'], 'device': ['cpu'], 'gpu_platform': ['none']}" \
    --output-folder $OUTPUT_FOLDER

chmod g-w $OUTPUT_FOLDER -R

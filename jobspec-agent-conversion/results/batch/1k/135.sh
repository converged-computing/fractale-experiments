#!/bin/bash
#FLUX: --job-name=llama-cpp-map
#FLUX: --time-limit=30m
#FLUX: --ntasks=1
#FLUX: --cores-per-task=20
#FLUX: --output=map.out
#FLUX: --error=map.err


if [ "$USER" == "filippo.bistaffa" ]
then
    spack load --first py-pandas
else
    module load python/3.9.9
fi

# srun is not required for a single task job in Flux
python3 map.py --seed $RANDOM

#!/bin/bash
#FLUX: --job-name=409wP48a1000tc
#FLUX: --time-limit=10m
#FLUX: --nodes=1
#FLUX: --ntasks=10

# The PBS memory request (-l mem) has no direct analog in flux and has been omitted.

cd /panfs/roc/groups/12/siepmann/singh891/projects/signac/cp2k/iodine

module load mkl
module load fftw
module load intel/cluster/2018
module load python
/panfs/roc/msisoft/anaconda/anaconda3-2018.12/bin/python project.py exec run_config 4a54cb77289f361a77be93e891eda4d4
/panfs/roc/msisoft/anaconda/anaconda3-2018.12/bin/python project.py exec run_config 0154c40573aade595a99b583a90d3945

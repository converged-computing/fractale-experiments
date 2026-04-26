#!/usr/bin/bash
#FLUX: --job-name=StatsR3
#FLUX: --time-limit=1d
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --ntasks=1


# module load python3
module purge
module load easybuild intel/2017a Python/3.6.1; which python

/usr/bin/time python3 posStatsN.py > statsR3.txt

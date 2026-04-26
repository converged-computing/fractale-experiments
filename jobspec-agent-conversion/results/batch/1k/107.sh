#!/bin/bash
#FLUX: --job-name=1637
#FLUX: --output=out.log
#FLUX: --error=err.log
#FLUX: --ntasks=16
#FLUX: --tasks-per-core=1
#FLUX: --ntasks-per-node=16
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=6h
#FLUX: --cwd=.

module purge
module load intel/2019.1.144
module load openmpi/4.0.1

flux run -n 16 /home/joshuapaul/vasp_10-23-19_5.4.4/bin/vasp_stand > job.log
echo Done

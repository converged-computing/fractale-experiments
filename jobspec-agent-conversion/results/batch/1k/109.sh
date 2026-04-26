#!/bin/bash
#FLUX: --job-name=1830
#FLUX: -o out_%j.log
#FLUX: -e err_%j.log
#FLUX: --ntasks=16
#FLUX: --tasks-per-node=16
#FLUX: --nodes=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=6h



# cd $SLURM_SUBMIT_DIR # This is the default behavior in Flux

module purge
module load intel/2019.1.144
module load openmpi/4.0.1

# 'srun' is replaced with 'flux run'
flux run -n 16 /home/joshuapaul/vasp_10-23-19_5.4.4/bin/vasp_stand > job.log
echo Done

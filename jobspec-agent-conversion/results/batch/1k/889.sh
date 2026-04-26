#!/bin/bash
#FLUX: --job-name=job_1
#FLUX: --output=std-out
#FLUX: --time-limit=1d
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1



export OMP_NUM_THREADS=10
# cd $SLURM_SUBMIT_DIR # This is the default behavior in Flux

# 'mpirun' is replaced with 'flux run'
flux run -n 1 /home/myless/VASP/vasp.6.3.2/bin/vasp_std
exit

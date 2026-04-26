#!/bin/bash
#FLUX: --job-name=rfm_Sysinfo_job
#FLUX: --ntasks=4
#FLUX: --tasks-per-node=1
#FLUX: --output=rfm_Sysinfo_job.out
#FLUX: --error=rfm_Sysinfo_job.err
#FLUX: --time-limit=10m

# The SLURM_MPI_TYPE variable is not needed in Flux.
python sysinfo.py
echo Done

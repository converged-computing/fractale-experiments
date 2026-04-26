#!/bin/bash
#FLUX: --job-name=array-job
#FLUX: --output=slurm-{flux:jobid}.{flux:cc}.out
#FLUX: --error=slurm-{flux:jobid}.{flux:cc}.err
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: -t 1m
#FLUX: --cc=0-2

# NOTE: The SLURM directive '--mem-per-cpu=4G' was omitted as there is no direct Flux equivalent.
# This may impact scheduling and could lead to the job running on a node with insufficient memory.

echo "My FLUX_JOB_ID is $FLUX_JOB_ID."
echo "My FLUX_JOB_CC (array task ID) is $FLUX_JOB_CC"
echo "Executing on the machine:" $(hostname)

module purge
module load anaconda3/2023.9

python myscript.py

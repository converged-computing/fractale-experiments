#!/bin/bash -l
#FLUX: --ntasks=24
#FLUX: --job-name=python-mpi	
#FLUX: --time-limit=10h
#FLUX: --cores-per-task=2

# The --mem-per-cpu slurm parameter has no direct analog in flux submit.
# This may affect job scheduling and performance if the job is memory-intensive.
# Slurm's dynamic output/error filenames (%J) are not supported in Flux directives.
# We redirect the output in the script body using the FLUX_JOB_ID variable instead.

module load gcc/5.4.0
module load intelmpi/5.1.3
module load hdf5-par/1.8.18
module load python-env/3.5.3
export PATH="$USERAPPL/appl_taito/myconda3/bin:$PATH"
export PYTHONPATH="$USERAPPL/myconda3/"
export PYTHONPATH="$PYTHONPATH:$PENCIL_HOME/python"
module list
source activate $USERAPPL/myconda3

flux mini run -n 24 python local_fort2h5.py > python-mpi${FLUX_JOB_ID}.out 2> python-mpi${FLUX_JOB_ID}.err

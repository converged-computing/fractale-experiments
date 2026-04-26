#!/bin/bash
#FLUX: --time-limit=15m
#FLUX: --nodes=1
#FLUX: --cores=32

# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd ${PBS_O_WORKDIR}

module load shifter

shifterimg pull luntlab/cs547_project:latest

export OMP_NUM_THREADS=32
# aprun is removed. The shifter command is now run directly.
shifter --image=docker:luntlab/cs547_project:latest --module=mpich,gpu -- python ./src/validate_dataset.py

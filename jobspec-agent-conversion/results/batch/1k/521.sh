#!/bin/bash

#FLUX: --job-name=NNP-mpi
#FLUX: --output=_scheduler-stdout.txt
#FLUX: --error=_scheduler-stderr.txt
#FLUX: --nodes=1
#FLUX: --ntasks=21
#FLUX: --time-limit=71h50m
#FLUX: --requires=E5v4

# The Slurm directive --get-user-env has no direct analog in Flux.
# Flux inherits the user's environment by default, which is generally the intended behavior.
# The original script requested 28 tasks with #SBATCH but only launched 21 with srun; this conversion uses the launch count of 21.

set +e
source $MODULESHOME/init/bash    # necessary in the case of zsh or other init shells
module load intel intel-mpi intel-mkl gsl eigen 
export OMP_NUM_THREADS=1


/home/glensk/Dropbox/Albert/git/n2p2/bin/nnp-train

exit 0

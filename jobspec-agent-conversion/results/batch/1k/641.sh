#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=24
#FLUX: --output=stdout_log.%j.o
#FLUX: --error=stderr_log.%j.e
#FLUX: --job-name=qsub_example

GMX_VERSION=4.6.7
DEFFNM="md"
TPR="md.tpr"
CPT="state.cpt"

# Capture the submission directory at the start of the job
SUBMIT_DIR=$(pwd)

# Use FLUX_JOB_ID for a unique directory name
WORK=/scratch/${USER}/WORK/${FLUX_JOB_ID}

mkdir -p $WORK
test -d $WORK || { echo "Could not make directory: ${WORK}"; exit 2; }

cp $CPT $TPR $WORK
cd $WORK || { echo "Could not change directory to: ${WORK}"; exit 2; }

module purge
module load gromacs/${GMX_VERSION}
module load cuda/8.0.61

# Launch the MPI application with 'flux run'
flux run -n 24 mdrun_mpi -s $TPR -nsteps 1000 -cpi state.cpt

cp * $SUBMIT_DIR

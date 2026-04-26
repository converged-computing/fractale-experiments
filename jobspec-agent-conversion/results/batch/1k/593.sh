#!/bin/bash
# Submission script for NIC5 
#FLUX: --job-name=vector-validation
#FLUX: --time-limit=15m

# The following SLURM directives were commented out and depend on undefined variables:
# ##SBATCH --ntasks=${MY_NTASKS}
# ##SBATCH --cpus-per-task=${MY_NTHREADS}
# The resource request for this job is incomplete without these variables defined.


export OMP_NUM_THREADS=${MY_NTHREADS}

echo "----------------- Load modules -----------------"
module purge
module load FFTW/3.3.8-gompi-2020b HDF5/1.10.7-gompi-2020b
module list


#HOME_FLUPS=/home/ucl/tfl/tgillis/flups
EXEC_FLUPS=flups_validation_nb
#
#SCRATCH=$GLOBALSCRATCH/${SLURM_JOB_NAME}_${SLURM_JOB_ID}
#
#mkdir -p $SCRATCH
#mkdir -p $SCRATCH/data
#mkdir -p $SCRATCH/prof
#
#cp $HOME_FLUPS/$EXEC_FLUPS $SCRATCH
#
#cd $SCRATCH

# The original srun command has been replaced with a standard mpirun.
# The Flux equivalent would be 'flux mini run -n ${MY_NTASKS} ...'
# However, the number of tasks `${MY_NTASKS}` is not defined in the script.
mpirun ${EXEC_FLUPS} -np ${MY_NX} ${MY_NY} ${MY_NZ} -res ${MY_SIZEX} ${MY_SIZEY} ${MY_SIZEZ} -nres ${MY_NRES} -ns ${MY_NSOLVE} -k ${MY_KERNEL} -c 0 -bc ${MY_BC}

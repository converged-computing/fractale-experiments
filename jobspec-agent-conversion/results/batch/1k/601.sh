#!/bin/sh
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --job-name=ankit_lammps

# The PBS directive to join output/error streams (-j oe) has no analog and was omitted.
# The PBS directive to make the job non-rerunnable (-r n) has no analog and was omitted.

# This job's working directory
echo "Job ID: $FLUX_JOB_ID"
echo "Working directory is $FLUX_SUBMIT_DIR"
cd $FLUX_SUBMIT_DIR
echo "Running on host $(hostname)"
echo "Time is $(date)"
echo "Directory is $(pwd)"
echo "This job runs on the following processors:"
echo "$FLUX_NODELIST"


RUNPATH=/home/jason/ankit/lammps/
EXEPATH=/home/jason/lammps/lammps-23Apr12/src

cd $RUNPATH

# The mpirun command has been replaced with flux mini run
flux mini run -n 1 $EXEPATH/lmp_openmpi < $RUNPATH/input.dat

#python 2_replaceXYZ.py

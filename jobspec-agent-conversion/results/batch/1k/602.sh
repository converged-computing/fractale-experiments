#!/bin/sh
#FLUX: -N 1
#FLUX: -n NUM_CPU
#FLUX: --job-name=nmd_grep

# The PBS directive to join output/error files ('-j oe') has no direct Flux translation and was omitted.
# The PBS directive for non-rerunable job ('-r n') has no direct Flux translation and was omitted.
# Queue and environment export directives were ignored as per instructions.
# The placeholder 'NUM_CPU' must be replaced with a number before submission.

# This job's working directory
echo Job ID: $FLUX_JOB_ID
# Information from PBS_O_WORKDIR and PBS_NODEFILE has been removed as they have no direct Flux equivalent.
echo Running on host `hostname`
echo Time is `date`
echo Directory is `pwd`


RUNPATH=runpath
EXEPATH=/home/jason/matlab/matlab_R2010a/bin

cd $RUNPATH

# Replaced mpirun with flux mini run
flux mini run -n NUM_CPU $EXEPATH/matlab -nodesktop < $RUNPATH/nmd_grep.m

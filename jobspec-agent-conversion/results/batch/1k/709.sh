#!/bin/bash -l
 
#FLUX: --job-name=XXXnameXXX
#FLUX: --ntasks=XXXmpinodesXXX
#FLUX: --gpus-per-task=1
#FLUX: --nodes=1
#FLUX: --time-limit=XXXextra1XXX
#FLUX: --error=XXXerrfileXXX
#FLUX: --output=XXXoutfileXXX

# The LSF GPU options 'mode=exclusive_process:j_exclusive=no:mps=no' have no direct analog in Flux.
# The LSF resource requirement 'span[hosts=1]' is approximated by --nodes=1.
# The -B (begin time) and -P (project) flags were ignored as per instructions.
 
# setup environment
source /etc/profile.d/modules.sh
export MODULEPATH=/usr/share/Modules/modulefiles:/opt/modulefiles:/afs/slac/package/singularity/modulefiles
module purge
module load PrgEnv-gcc/4.8.5
module load relion/2.1

# set tmpdir for relion
# Note: LSB_JOBID is an LSF variable. You may need to replace this with a Flux equivalent like FLUX_JOB_ID.
export TMPDIR=/scratch/${USER}/${LSB_JOBID}/TMPDIR/

# run relion
XXXcommandXXX 

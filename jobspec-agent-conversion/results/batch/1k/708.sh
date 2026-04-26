#!/bin/bash -l
 
#FLUX: --job-name=XXXnameXXX
#FLUX: --queue=XXXqueueXXX
#FLUX: --ntasks=XXXmpinodesXXX
#FLUX: --time-limit=XXXextra1XXX
#FLUX: --error=XXXerrfileXXX
#FLUX: --output=XXXoutfileXXX


# other
# threads: XXXthreadsXXX
# cores: XXXcoresXXX
# dedicated: XXXdedicatedXXX
# mem: XXXextra2XXX
# unused: XXXextra3XXX

# setup environment
source /etc/profile.d/modules.sh
export MODULEPATH=/usr/share/Modules/modulefiles:/opt/modulefiles:/afs/slac/package/singularity/modulefiles
module purge
module load PrgEnv-gcc
module load relion/${RELION_VERSION}

# set tmpdir for relion
# NOTE: $LSB_JOBID has been replaced with $FLUX_JOB_ID
export TMPDIR=/scratch/${USER}/${FLUX_JOB_ID}/TMPDIR/

# run relion
# 'mpirun' is replaced with 'flux run'
flux run -n XXXmpinodesXXX XXXcommandXXX 

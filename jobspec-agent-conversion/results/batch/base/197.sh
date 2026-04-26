#!/bin/bash
#PBS -S /bin/bash
#FLUX: --bank=cosmo
#FLUX: --queue=qualified
#FLUX: --nodes=20
#FLUX: --cores=28
#FLUX: --ntasks=560
#FLUX: --time-limit=15h
#FLUX: --job-name=WF3x2_sy_p_MG
#FLUX: --error=/home/u17/timeifler/output/
#FLUX: --output=/home/u17/timeifler/output/

# The PBS memory request 'mem=168GB' has no direct equivalent in flux-submit.
# The job may fail due to insufficient memory.
# The PBS placement option 'place=free:shared' has no direct equivalent in flux-submit.
# The PBS CPU time limit 'cput=8400:00:00' has no direct equivalent in flux-submit.


# The 'cd $PBS_O_WORKDIR' command is not needed as Flux jobs start in the submission directory by default.

module load python/2
module load mpich/ge/gcc/64/3.2.1
module load openmpi

### run your executable program with begin and end date and time output
export MPI_DSM_DISTRIBUTE
date

# The mpiexec command has been replaced with flux run.
/usr/bin/time flux run python runWFIRST_3x2pt_allsys_pessi_MG.py
date

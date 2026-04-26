#!/bin/bash
# The -S, -W group_list, and -q directives are ignored.
# The PBS select statement is translated to the following flux directives:
#FLUX: --nodes=20
# The ncpus=28 is interpreted as tasks-per-node as this is an MPI job.
#FLUX: --tasks-per-node=28
# The mem=168GB directive has no direct flux analog and is omitted.
# The place=free:shared directive has no direct flux analog and is omitted.
# The cput=8400:00:00 directive has no direct flux analog and is omitted.
#FLUX: --time-limit=15h
#FLUX: --job-name=WF3x2_sy_p_MG
#FLUX: --error=/home/u17/timeifler/output/
#FLUX: --output=/home/u17/timeifler/output/


# The PBS_O_WORKDIR variable is replaced by FLUX_JOB_CWD
cd $FLUX_JOB_CWD

module load python/2
module load mpich/ge/gcc/64/3.2.1
module load openmpi

### run your executable program with begin and end date and time output
export MPI_DSM_DISTRIBUTE
date
# The mpiexec command is replaced by `flux mini run`
# The -n 560 is automatically handled by the resource specification (20 nodes * 28 tasks/node = 560 tasks)
/usr/bin/time flux mini run python runWFIRST_3x2pt_allsys_pessi_MG.py
date

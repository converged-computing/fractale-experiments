#!/bin/bash

#FLUX: --job-name=jobname
#FLUX: --time-limit=24h
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --gpus-per-node=4
#FLUX: --requires=gpu
#FLUX: --error=job-%j.err
#FLUX: --output=job-%j.out

# The -d singleton directive has no direct analog in the provided flux submit options.
# The --output and --error directives do not support Slurm-style job ID substitution (%j).
# The SLURM_JOB_CPUS_PER_NODE variable has been replaced by FLUX_JOB_NCORES.

# The actual script starts here
module unload gromacs
module switch gromacs/2023 gromacs=gmx_mpi
module switch cuda/11.8
module unload openmpi
module load openmpi

gmx_mpi mdrun -deffnm md -cpi md -multidir rep1 rep2 rep3 rep4 -ntomp $((FLUX_JOB_NCORES/4)) -maxh 23

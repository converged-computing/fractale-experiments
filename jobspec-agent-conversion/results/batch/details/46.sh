#!/bin/bash

#FLUX: --job-name=gromacstest
# The --partition=GPU directive is ignored as per instructions.
#FLUX: --gpus-per-task=1
# The Slurm directives --ntasks=10 and --cpus-per-task=1 are interpreted as a request
# for a single threaded process using 10 cores.
#FLUX: --ntasks=1
#FLUX: --cores-per-task=10
#FLUX: --time-limit=1h 

export GMX_IMGDIR=${SIFDIR}/gromacs/
export GMX_IMG=gromacs-2022.3_20230206.sif
export TOPOL_FILE=topol.tpr

# The SLURM_NTASKS variable is replaced with FLUX_JOB_NCORES to get the total number of cores allocated.
singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd  $GMX_IMGDIR/$GMX_IMG gmx mdrun -ntmpi 1 -nb gpu -pin on -v -noconfout -nsteps 5000 -ntomp ${FLUX_JOB_NCORES} -s $TOPOL_FILE
#DO NOT USE 'srun' as it launches multiple independent jobs

#!/bin/bash
#FLUX: --nodes=4
#FLUX: --time-limit=2h
#FLUX: --job-name=q0.90_ovl2.5


export CRAY_CUDA_MPS=1
source $MODULESHOME/init/bash
module load gromacs/5.1.0

# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR

# Extend the run - aprun replaced with flux run
flux run -n 1 gmx_mpi grompp -f relax_2.mdp -c relax_1.gro -p confinedBSA.top -o relax_2.tpr

# 8 MPI ranks per node, each one tied to 2 openMP threads - aprun replaced with flux run
# We request 32 tasks total, 8 per node, and 2 cores per task to match the original layout.
flux run -n 32 -N 8 --cores-per-task=2 gmx_mpi mdrun -ntomp 2 -gpu_id 00000000 -s relax_2.tpr -deffnm relax_2

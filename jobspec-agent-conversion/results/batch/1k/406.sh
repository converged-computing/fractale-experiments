#!/bin/sh
#FLUX: --job-name=grompp
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=10m
#FLUX: --cwd=.

# Go to the directory from where the job was submitted (initial directory is $HOME)
echo Working directory is .
### Here follows the user commands:
# Define number of processors
NPROCS=$(flux resource list -o hosts | wc -l)
echo This job has allocated $NPROCS nodes
# Load all required modules for the job
module load tools
module load cuda/toolkit/10.2.89 openmpi/gcc/64/1.10.2 gcc/9.3.0
gmx=/home/projects/ku_10001/apps/GMX20203/bin/gmx_mpi
$gmx grompp -f ../../md_Martini_${temp}K.mdp -p all_PRO_lambda.top -c relax.gro -t relax.cpt -o prodrun.tpr -maxwarn 2 -v


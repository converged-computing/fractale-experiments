#!/bin/sh
#FLUX: --job-name=GROMACS
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=2
#FLUX: --ntasks=2
#FLUX: --cores-per-task=6
#FLUX: --gpus-per-node=2
#FLUX: --time-limit=15m
#FLUX: --cwd=.


source /home/$USER/software/gromacs-2023.3/build_slurm/gmx/bin/GMXRC
module load openmpi/4.1.5 intel-oneapi-mkl/2022.2.1 anaconda3/2022.10 

# get the total number of MPI processes
echo number of MPI processes is $FLUX_NTASKS

# generate binary input file
flux run -n 1 gmx_mpi grompp -f rf_verlet.mdp -p topol.top -c conf.gro -o em.tpr

flux run -n 2 gmx_mpi mdrun -s em.tpr -deffnm job-output


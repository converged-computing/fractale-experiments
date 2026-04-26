#!/bin/bash
#FLUX: --job-name=em2KJJpTc36m5
#FLUX: --output=em2KJJpTc36m5.log
#FLUX: --time-limit=5h
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: --cwd=/lustre/platr0008/wittler/MDRUNS/2KJJpTc36mno5/m5MD

date -u '+%Y-%m-%d %TZ %a'
hostname
echo 'Run GROMACS'

module load gromacs/5.0.4-openmpi-gcc

gmx grompp -f em.mdp -c solv_ions.gro -p topol.top -po emout.mdp -o em.tpr
gmx mdrun -deffnm em -ntomp 16 -ntmpi 1

date -u '+%Y-%m-%d %TZ %a'


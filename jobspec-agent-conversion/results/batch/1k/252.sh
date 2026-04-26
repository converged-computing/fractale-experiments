#!/bin/bash
#FLUX: --job-name=1p2KJJpTc36m5
#FLUX: --output=1p2KJJpTc36m5.log
#FLUX: --nodes=1
#FLUX: --ntasks=16
#FLUX: --time-limit=500h

# The following PBS directives could not be translated:
# -l mem=60G (memory request)
# -r n (not rerunnable)
# -j oe (join stdout/stderr)
# This may impact job scheduling, resource allocation, and behavior on failure.

date -u '+%Y-%m-%d %TZ %a'
hostname
echo 'Run GROMACS'

cd /home/hpw572/MDRUNS/2KJJEXP/2KJJpTc36mno5/m5MD

source /usr/share/modules/init/bash
module load gromacs/5.0.4_intel_15.6

gmx_mpi grompp -f 1pmd.mdp -c npt_PR.gro -t npt_PR.cpt -p topol.top -po 1pmdout.mdp -o 1pmd.tpr
gmx_mpi mdrun -deffnm 1pmd 

date -u '+%Y-%m-%d %TZ %a'

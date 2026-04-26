#!/bin/bash
#FLUX: --job-name=cas9_nvt
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=16
#FLUX: --time-limit=3h
#FLUX: --gpus-per-task=1
#FLUX: --error=stack.err
#FLUX: --output=stack.txt

module load gromacs/2020.4
export OMP_NUM_THREADS=16

gmx mdrun -s nvt_fix.tpr -v -ntmpi 1 -deffnm mark_cas9_nvt 

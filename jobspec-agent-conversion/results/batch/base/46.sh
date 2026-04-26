#!/bin/bash

#FLUX: --job-name=gromacstest
#This sets the name of the job

#FLUX: --queue=GPU
#This sets the partition to the GPU partition. Important for GPU jobs

#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#This allocates 1 GPU on a single node. Important for GPU jobs

#FLUX: --ntasks=10
#This sets the number of processes to 10.

#FLUX: --cores-per-task=1
#This allocates the number of cpus per tasks. 

#FLUX: --time-limit=1h
#This allocates the walltime to 60 minutes. The program will not run for longer.

export GMX_IMGDIR=${SIFDIR}/gromacs/
export GMX_IMG=gromacs-2022.3_20230206.sif
export TOPOL_FILE=topol.tpr

singularity run --nv -B ${PWD}:/host_pwd --pwd /host_pwd  $GMX_IMGDIR/$GMX_IMG gmx mdrun -ntmpi 1 -nb gpu -pin on -v -noconfout -nsteps 5000 -ntomp ${FLUX_NTASKS} -s $TOPOL_FILE
#DO NOT USE 'srun' as it launches multiple independent jobs


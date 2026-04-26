#!/bin/sh
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --job-name=step-4u_0.8000-0.0

/home/yfwang09/Codes/lammps/src/lmp_icc_serial -sf gpu -pk gpu 1 -in /home/yfwang09/Codes/MLmat/MetallicGlass/data/natom-5000/qrate-2.8e+07/sample_0/erate-1.0e+07/strain_0-4.0/T2K/lammps_scripts/in.4u_0.8000-0.0
wait

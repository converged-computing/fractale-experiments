#!/bin/bash
#FLUX: --job-name=q6
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=8
#FLUX: --time-limit=6h

module load apps/gromacs-2019.3
export OMP_NUM_THREADS=8

# The original 'srun -n 1' commands have been replaced with the standard Flux launcher 'flux mini run'.
flux mini run -n 1 gmx_mpi grompp -p trappe -f nvt_qua_steep -c qua_ow_400_12000_h60 -o qua_ow_400_12000_h60
flux mini run -n 1 gmx_mpi mdrun -s -o -x -c -e -g -v -deffnm qua_ow_400_12000_h60
rm ./*pdb
flux mini run -n 1 gmx_mpi grompp -p trappe -f nvt_qua_short -c qua_ow_400_12000_h60 -o qua_ow_400_12000_h60
flux mini run -n 1 gmx_mpi mdrun -s -o -x -c -e -g -v -deffnm qua_ow_400_12000_h60
flux mini run -n 1 gmx_mpi grompp -p trappe -f nvt_qua -c qua_ow_400_12000_h60 -o qua_ow_400_12000_h60
flux mini run -n 1 gmx_mpi mdrun -s -o -x -c -e -g -v -deffnm qua_ow_400_12000_h60
rm ./#*#

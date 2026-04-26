#!/bin/bash
#
#FLUX: --job-name=25f_q2_res
#FLUX: --output=dfc2500_job.out
#FLUX: --tasks-per-node=27
#FLUX: --nodes=8
#FLUX: --time-limit=2d
#FLUX: --ntasks=216


module load shared
module load mvapich2/gcc/64/2.2rc1
module load lammps/gcc/3Mar2020-bigbig

cd $HOME/25f_q2_res

# 'mpirun' is replaced with 'flux run'
flux run -n 216 lmp_bigbig < hydrogel_test.in > output.txt 

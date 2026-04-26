#!/bin/bash
#
#FLUX: --job-name=100f_q1_res
#FLUX: --output=output.txt
#FLUX: --tasks-per-node=27
#FLUX: --nodes=8
#FLUX: --ntasks=216
#FLUX: --time-limit=48h
#FLUX: --input=hydrogel_test.in

module load shared
module load mvapich2/gcc/64/2.2rc1
module load lammps/gcc/3Mar2020-bigbig

cd $HOME/100f_q1_res

flux run lmp_bigbig

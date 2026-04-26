#!/bin/bash
#FLUX: --time-limit=1d
#FLUX: --nodes=4
#FLUX: --tasks-per-node=6
#FLUX: --ntasks=24


# Add any the intel compiler and MPT MPI modules
#module reset
#module load mkl mpiblast python
#module swap intel gcc
#module load mkl python
#module load mkl mpt python
#module load intel mpt
#module add mpiblast 
#module load openmpi

#module load mkl mpiblast python

module reset
#module swap openmpi
#module swap mvapich2 openmpi
module load mkl python openmpi




cd /work/hokieone/ilikeit/057139_000656029
cp /home/ilikeit/hokieone/ft.py .
cp /home/ilikeit/hokieone/errors.py .
cp /home/ilikeit/hokieone/drx.py .
cp /home/ilikeit/hokieone/dp.py .

# 'mpirun' is replaced with 'flux run'
flux run -n 24 python ft.py 057139_000656029

echo "done"
exit;

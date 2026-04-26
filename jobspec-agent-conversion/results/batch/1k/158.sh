#!/bin/bash
#FLUX: --nodes=8
#FLUX: --ntasks=8
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: --job-name=life_hpc_n8



module load pgi openmpi/1.6.5--pgi--14.1

#ulimit -m
# cd /eurora/home/userexternal/ralfieri/life/openacc/game-of-life # Assuming this is the submission directory

# The PBS_NODEFILE is not available in Flux
# cat $PBS_NODEFILE

mpicc -O3 life_hpc.c -acc -DCOMP -DMPI -ta=nvidia -Minfo=accel -lpgacc -o life_hpc_acc_mpi

for N in $(echo 8 4 2 1)
do
for DIM in $(echo 17000 8000 4000 2000 1000 )
do 
for COMP in $(echo 1000 100 10 0)
do
# 'mpirun' is replaced with 'flux run'
CMD="flux run -n $N ./life_hpc_acc_mpi -r $DIM -c $DIM -n $COMP -s 10 -d 0"
echo "# $CMD"
eval $CMD
done
done
done

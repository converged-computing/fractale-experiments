#!/bin/sh
#FLUX: --job-name=temp77
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --cores-per-task=24
#FLUX: --time-limit=1h




# echo "==============================="
echo $FLUX_JOB_ID
# The functionality of PBS_NODEFILE is not directly available in the same format.
# You can get the hostname of the node with 'hostname'.
echo $(hostname)
echo "==============================="

# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR

#job 
module load apps/lammps/gpu
nvcc cuda_multiplication.cu
time ./a.out sample_inp.txt output_inp.txt

#!/bin/bash -x
#FLUX: --nodes=49
#FLUX: --ntasks=196
#FLUX: --tasks-per-node=4
#FLUX: --cores-per-task=12
#FLUX: --gpus-per-task=1
#FLUX: --output=job.out
#FLUX: --error=job.err
#FLUX: --time-limit=1h30m

# Set OMP_NUM_THREADS explicitly based on the cores-per-task request.
export OMP_NUM_THREADS=12

ml Stages/2023 GCC OpenMPI CUDA imkl CMake Boost git

DMAX=70
N=210000

for i in {1..4}
do
# The --threads-per-core srun option has no direct flux analog and was omitted.
flux mini run -n 196 ../ChASE/build/examples/2_input_output/2_input_output_mgpu --n $N --path_in=0 --isMatGen=true --dmax=${DMAX} --nev 2250 --nex 750 --complex 0 --tol 1e-10 --opt S --deg 20 --mode R --maxIter 1
done

#!/bin/bash

#FLUX: --job-name=LAMMPS_DATA
#FLUX: --output=%x.%j.o
#FLUX: --error=%x.%j.err
#FLUX: --nodes=1
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=40


# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.

set -euf -o pipefail

#readonly gpu_count=${1:-$(nvidia-smi --list-gpus | wc -l)}
readonly gpu_count=1
readonly input=${LMP_INPUT:-in.lj.txt}

# TODO: inject one line to set the GPU freq via Slurm

ml gcc/8.4.0 openmpi/4.0.4-cuda lammps/20200505-cuda-mpi-openmp
echo "Running Lennard Jones 8x4x8 example on ${gpu_count} GPUS..."
./init.sh ./demo.sh DEMO

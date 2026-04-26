#!/bin/sh
#FLUX: --queue=i1accs
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=64
#FLUX: --time-limit=15m
#FLUX: --job-name=GCNLMP

# The PBS directives for mpiprocs and ompthreads were contradictory to the ncpus request.
# This script allocates 64 cores to the single task, assuming the application is multi-threaded.


module purge
module load openmpi_nvhpc/4.1.2
module load nvhpc-nompi/22.2_cuda11.6

source ~/miniconda3/etc/profile.d/conda.sh
conda activate nequip_GPU2

export CUDA_VISIBLE_DEVICES="0"

./lmp -in input.data

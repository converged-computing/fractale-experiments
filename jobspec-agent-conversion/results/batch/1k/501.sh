#!/bin/sh
#FLUX: --queue=i1accs
# The PBS select statement is translated to the following flux directives:
#FLUX: --nodes=1
#FLUX: --cores-per-task=64
#FLUX: --ntasks=1
#FLUX: --time-limit=15m
#FLUX: --job-name=GCNLMP

module purge
module load openmpi_nvhpc/4.1.2
module load nvhpc-nompi/22.2_cuda11.6

source ~/miniconda3/etc/profile.d/conda.sh
conda activate nequip_GPU2

# NOTE: Flux manages GPU visibility automatically. This line is usually not needed.
# export CUDA_VISIBLE_DEVICES="0"

./lmp -in input.data

#!/bin/bash
#FLUX: --gpus-per-node=8
#FLUX: --cores-per-task=46
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=8
#FLUX: --ntasks=8
#FLUX: --exclusive
#FLUX: --output=job4.o
#FLUX: --error=job4.e
#FLUX: --time-limit=6d


/bin/bash
conda activate hetero_mod
module load python/3.8.9
module load openmpi/4.1.0/gcc.7.3.1/rocm.4.2


# srun is not required for a single task job in Flux
python dataset_test.py
wait

#!/bin/bash -l
# Batch directives
#FLUX: --gpus-per-node=1
#FLUX: --requires=v100
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --bank=NTDD0002
#FLUX: --queue=dav
#FLUX: --time-limit=15m
#FLUX: --output=log.matmul_{id}.out
#FLUX: --job-name=GPU_matmul

# The --reservation=casper_8xV100 parameter from slurm has no direct equivalent in flux-submit.

# Load the necessary modules (software)
module purge
module load ncarenv/1.2
module load nvhpc/20.11
module list

# Update LD_LIBRARY_PATH so that cuda libraries can be found
export LD_LIBRARY_PATH=${NCAR_ROOT_CUDA}/lib64:${LD_LIBRARY_PATH}
echo ${LD_LIBRARY_PATH}
nvidia-smi

export PCAST_COMPARE=abs=6,summary

# Move to the correct directory and run the executable
echo -e "\nBeginning code output:\n-------------\n"
./matmul.exe 

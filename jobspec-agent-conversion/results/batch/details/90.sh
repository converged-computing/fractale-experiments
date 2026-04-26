#!/bin/bash -l
# The gres directive is translated into a gpu-per-task request and a constraint
#FLUX: --gpus-per-task=1
#FLUX: --requires=v100
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
# The --account, --partition, and --reservation directives are ignored or have no analog.
#FLUX: --time-limit=15m
#FLUX: --output=log.matmul_%j.out
#FLUX: --job-name=GPU_matmul

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
# The srun command is replaced by `flux mini run`
flux mini run ./matmul.exe 

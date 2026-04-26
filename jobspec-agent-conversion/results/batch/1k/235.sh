#!/bin/bash
#FLUX: --job-name=testGPU
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --time-limit=1h
#FLUX: --gpus-per-node=1
#FLUX: --output=%J.out

module purge

module load StdEnv/2020 apptainer/1.1.8


#echo $PATH
#echo $LD_LIBRARY_PATH

echo "== This is the scripting step! =="
./runIN_sing.sh
#which nvidia-smi
#nvidia-smi
echo "== End of Job =="

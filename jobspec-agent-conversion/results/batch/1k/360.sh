#!/bin/bash
#FLUX: --job-name=DelSwitch
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --cc=0-6
#FLUX: --output=/homedtic/gjimenez/DADES/DADES/Delineator/Logs/DelSwitch.out
#FLUX: --error=/homedtic/gjimenez/DADES/DADES/Delineator/Logs/DelSwitch.err
#FLUX: --cwd=/homedtic/gjimenez/GitHub/DelineatorSwitchAndCompose

module load Python/3.6.4-foss-2017a;
module load PyTorch/1.6.0-foss-2017a-Python-3.6.4-CUDA-10.1.105;
module load OpenBLAS/0.2.19-foss-2017a-LAPACK-3.7.0;
module load OpenMPI/2.0.2-GCC-6.3.0-2.27;

export OMP_NUM_THREADS=$FLUX_CPUS_PER_TASK;

source ~/VirtEnv/DeepLearning3/bin/activate;
python3 train_multi.py --config_file ./configurations/HPC/${FLUX_JOB_CC}.json --input_files ./pickle/ --model_name TESTF1Loss_${FLUX_JOB_CC} --hpc 1;



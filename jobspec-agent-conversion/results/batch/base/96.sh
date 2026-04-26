#!/bin/bash
#FLUX: --nodes=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=12
#FLUX: --gpus-per-task=2
#FLUX: --time-limit=40h
#FLUX: --job-name=ISBI_HR_aug
#FLUX: --queue=nvidia

# The SLURM --mem directive has no direct Flux analog in the provided documentation.
# The SLURM --mail-type and --mail-user directives have no direct Flux analog.

module purge
module load all
module load cuda/10.0
source activate py362
cd /scratch/lw1474/qiming/Video/MS_Lesion_seg
python  -u train_HRNet_ISBI.py --save_dir="./results_HRNet_ISBI">>Log/log_HRNet_ISBI_aug_tmp.txt

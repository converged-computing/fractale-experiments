#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=12
#FLUX: --gpus-per-task=2
#FLUX: --time-limit=40h
# The --mem 32000 directive has no direct flux analog and is omitted.
#FLUX: --job-name=ISBI_HR_aug
# The --mail-type and --mail-user directives are ignored as per instructions.
# The -p nvidia (partition) directive is ignored as per instructions.

module purge
module load all
module load cuda/10.0
source activate py362
cd /scratch/lw1474/qiming/Video/MS_Lesion_seg
python  -u train_HRNet_ISBI.py --save_dir="./results_HRNet_ISBI">>Log/log_HRNet_ISBI_aug_tmp.txt

#!/bin/bash

#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=8
#FLUX: --gpus-per-task=4
#FLUX: --time-limit=25h
#FLUX: --job-name=frame_pred
#FLUX: --output=logs/train_simvp_%j.out
#FLUX: --signal=SIGUSR1@90s


singularity exec --nv \
	    --overlay /scratch/tk3309/DL24/overlay-50G-10M.ext3:rw \
	    /scratch/tk3309/DL24/cuda11.8.86-cudnn8.7-devel-ubuntu22.04.2.sif \
	    /bin/bash -c "source /ext3/env.sh; python /scratch/tk3309/mask_dl_final/train.py"

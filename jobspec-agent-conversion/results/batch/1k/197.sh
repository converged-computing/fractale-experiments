#!/bin/sh
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=5
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=10m


# NOTE: Flux jobs typically start in the submission directory, so 'cd $PBS_O_WORKDIR' is not needed.
# cd $PBS_O_WORKDIR
module load cuda/10.1
module load singularity
singularity exec --nv --bind gax/:/mnt MainSB/ python /mnt/main_pneu.py --mode train --PROJECT_ID pneu_testrun --n_iter 64 --batch_size 4 --realtime_print 1 --n_debug 16 --ROOT_DIR gax 

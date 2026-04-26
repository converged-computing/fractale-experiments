#!/bin/bash
#FLUX: --job-name=ast_finetuned
#FLUX: --gpus-per-task=1
#FLUX: --requires=v100
#FLUX: --time-limit=2h
#FLUX: --output=ast_finetuned.out
#FLUX: --error=ast_finetuned.err

# load any software environment module required for app (e.g. matlab, gcc, cuda)
module load python/3.12
module load cuda/12.2

# load venv
source /nfs/hpc/share/dilgrenc/topnmusic/.venv/bin/activate

# run my job (e.g. matlab, python)
for lr in 5e-5
do
	for bs in 16
	do
   		.venv/bin/python3 ./src/topnmusic/ast_finetuned_audioset_finetuned_gtzan.py $lr $bs
    done
done

# interactive run
# srun -p dgxs --gres=gpu:1 --constraint=v100 --mem=10G --pty bash

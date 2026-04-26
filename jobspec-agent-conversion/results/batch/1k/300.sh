#!/bin/bash

#FLUX: -N 1
#FLUX: --gpus-per-node=1
#FLUX: --job-name=Eval_Bert
#FLUX: -t 1h
#FLUX: --output=slurm/outputs/eval_%A.out

# The SLURM directive '--mem 32G' was omitted as it has no direct Flux translation.
# The SLURM partition directive '--partition gpu' was ignored as per instructions.
# The filename substitution %A is not supported by Flux and will be treated literally.

source ./slurm/.secrets

module purge
module load 2022
module load Anaconda3/2022.05
module load PyTorch/1.12.0-foss-2022a-CUDA-11.7.0

source activate pex

#Copy data dir  to scratch
cp -r data  "$TMPDIR"/data
mkdir "$TMPDIR"/logs

# 'srun' is not needed for a single-task job in Flux.
python -u run/main.py eval bert classify \
        --basedir msc/msc_personasummary/  \
        --sessions 1 2 3 4 \
	--speaker_prefixes \<other\> \<self\> \
        --batch_size 64  \
        --device cuda  \
        --loglevel VERBOSE  \
        --logdir "$TMPDIR"/logs/  \
	--datadir "$TMPDIR"/data/ \
        --checkpoint_dir ./checkpoints/ \
	--output_dir ./output/ \
	--load trained_len3_bert  \

cp "$TMPDIR"/logs/* ./logs

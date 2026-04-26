#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores=28
#FLUX: --gpus-per-node=1
#FLUX: --job-name=rnn_character
#FLUX: --exclusive
#FLUX: --time-limit=24h
#FLUX: --error=/home/u25/dongfangxu9/concept_normalization/log/rnn_err
#FLUX: --output=/home/u25/dongfangxu9/concept_normalization/log/rnn_out


module load singularity/2/2.6.0

# Flux jobs are typically started in the submission directory ($PBS_O_WORKDIR)
# so a 'cd' command is not necessary.

singularity run --nv /extra/dongfangxu9/img/flair.img rnn_character.py

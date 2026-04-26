#!/bin/bash
#FLUX: --nodes=1
#FLUX: --output=logs/%x.%J.out
#FLUX: --error=logs/%x.%J.err
#FLUX: --time-limit=4h
#FLUX: --gpus-per-node=1
#FLUX: --requires=v100
#FLUX: --cores-per-task=4

# The following Slurm directives could not be translated:
# --mem=64G (memory request)
# --exclude (node exclusion)
# --output and --error filename substitutions (%x, %J)
# The script assumes it is run as part of a job array/concurrent set.

CONST=0

source activate rs_fl

nvidia-smi
echo $HOSTNAME

python certify.py \
--dataset $DATASET \
--model $MODEL \
--base_classifier $CHECKPOINT \
--experiment_name $EXP_NAME \
--certify_method $AUG_METHOD \
--sigma $SIGMA \
--num_clients $NUM_CLIENTS \
--client_idx ${FLUX_JOB_CC} \
--skip $SKIP --max $MAX

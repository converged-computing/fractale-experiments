#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --cc=0
#FLUX: --job-name=print
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=30m

module add openmind/singularity/3.4.1
hostname
singularity exec -B /om2:/om2 --nv /om/user/xboix/singularity/xboix-tensorflow2.5.0.simg \
 python3 /om2/user/vanessad/understanding_reasoning/experiment_3/main.py \
 --host_filesystem om2 \
--output_path results_NeurIPS_revision \
--offset_index 0 \
--experiment_index ${FLUX_JOB_CC} \
--run print

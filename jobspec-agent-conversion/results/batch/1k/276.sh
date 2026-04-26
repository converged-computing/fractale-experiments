#!/bin/bash
#FLUX: --job-name=mnist
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --time-limit=14h59m
#FLUX: --gpus-per-task=4
#FLUX: --cpus-per-task=12

# The slurm parameter --hint=nomultithread has no direct flux analog and was omitted.
# Slurm's dynamic output/error filenames (%j) are not supported in Flux directives.
# We redirect all output for the script using 'exec' and the FLUX_JOB_ID variable.
exec > monoscene_${FLUX_JOB_ID}.out 2> monoscene_${FLUX_JOB_ID}.err

module purge
conda deactivate
module load pytorch-gpu/py3/1.7.1
python $WORK/code/xmuda-extend/xmuda/train_2d_proj3d2d.py batch_size=4 n_gpus=4 enable_log=true exp_prefix=MoreConv_add16 project_1_2=true project_1_4=true project_1_8=true project_1_16=false run=3 dataset=NYU project_scale=4 frustum_size=8 class_proportion_loss=true context_prior=null n_relations=8 optimize_iou=true MCA_ssc_loss=true CE_relation_loss=false corenet_proj=null lr=1e-4 weight_decay=1e-4

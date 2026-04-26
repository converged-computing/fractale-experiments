#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=4
#FLUX: --ntasks=4
#FLUX: --cores-per-task=4
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=23h
#FLUX: --output=logs/res_%j.out
#FLUX: --error=logs/err_%j.err
#FLUX: --job-name='diffuseq-replica-decode'


# NOTE: The %j format specifier is not supported in Flux; files will be overwritten.

export WANDB_API_KEY=$(cat wandb_login.txt)
overlay=/scratch/ad6489/pytorch-example/overlay_img
img=/scratch/work/public/singularity/cuda11.8.86-cudnn8.7-devel-ubuntu22.04.2.sif

singularity exec --nv \
	--overlay $overlay:ro \
	$img \
       	/bin/bash -c \
	"source /ext3/env.sh; python -u /scratch/ad6489/thesis/DiffuSeq/scripts/run_decode.py \
	--model_dir diffusion_models/diffuseq_qqp_h128_lr0.0001_t2000_sqrt_lossaware_seed102_test-qqp20231109-01\:58\:16 \
	--seed 110 \
	--split test"

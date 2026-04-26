#!/bin/bash
#FLUX: --time-limit=30h
#FLUX: --gpus-per-node=2
#FLUX: --cores=10

# The PBS '-v' directive was converted to an export command
export OMP_NUM_THREADS=76

# PBS's $PBS_O_WORKDIR is equivalent to Flux's $FLUX_SUBMIT_DIR
cd $FLUX_SUBMIT_DIR

# Environment variables like GROUP_ID and USER are assumed to be present in the Flux environment
export SINGULARITY_BIND="`readlink -f /sqfs/work/$GROUP_ID/$USER`,$FLUX_SUBMIT_DIR"
nvidia-smi
python --version
singularity run --nv --bind /sqfs/work/$GROUP_ID/$USER_ID:/sqfs/work/$GROUP_ID/$USER_ID /sqfs/work/$GROUP_ID/$USER_ID/sif_images/lampp.sif python image_segmentation/blip-llm_inference.py --output=/sqfs/work/G15445/u6b795/lampp/blip-llm --data-dir=/sqfs/work/G15445/u6b795/SUNRGBD --cuda --last-ckpt=/sqfs/work/$GROUP_ID/$USER_ID/rednet_ckpt/ckpt_epoch_245.00.pth --visualize
# singularity run --nv --bind /sqfs/work/$GROUP_ID/$USER_ID:/sqfs/work/$GROUP_ID/$USER_ID /sqfs/work/$GROUP_ID/$USER_ID/sif_images/lampp.sif python test.py

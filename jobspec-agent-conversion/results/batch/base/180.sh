#!/bin/bash
#FLUX: --job-name=test
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --cores-per-task=1
#FLUX: --gpus-per-task=1
#FLUX: -q gpu-normal
#FLUX: --output=test.out
#FLUX: --error=test.err

# NOTE: The original script requested 4 nodes (-N 4) while the launch command was for a single node.
# This conversion assumes a single-node, 4-GPU job was intended to avoid wasting resources.
# NOTE: The SLURM partition directive '-p' was translated to the Flux queue directive '-q'.
# NOTE: The manual setting of CUDA_VISIBLE_DEVICES is often not required when Flux is managing
#       GPU resources, but is kept here for compatibility.
# NOTE: 'srun' is not required; the torch launcher is executed directly within the allocation.

export CUDA_VISIBLE_DEVICES=0,1,2,3

python -m torch.distributed.run --nproc_per_node=4 train_retrieval.py --config ./configs/retrieval_flickr_small6.yaml --output_dir output/retrieval_flickr

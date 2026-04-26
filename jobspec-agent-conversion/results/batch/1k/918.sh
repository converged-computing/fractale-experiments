#!/bin/bash
#FLUX: --job-name=test
#FLUX: --nodes=4
#FLUX: --tasks-per-node=4
#FLUX: --gpus-per-task=1
#FLUX: --output=test.out
#FLUX: --error=test.err

# The CUDA_VISIBLE_DEVICES environment variable is not set here.
# Flux will automatically manage GPU affinity, assigning one device
# per task, which is a more robust method.

# The srun wrapper around torch.distributed.run is replaced with a direct
# 'flux run' command. Flux and PyTorch handle the distributed setup.
flux run python train_retrieval.py --config ./configs/retrieval_flickr_small6.yaml --output_dir output/retrieval_flickr

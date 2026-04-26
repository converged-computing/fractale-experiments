#!/bin/bash -l
#FLUX: --job-name=goes16ci
#FLUX: --time-limit=5h
#FLUX: --nodes=1

# NOTE: The node count was not specified and has been assumed to be 1.
# NOTE: The memory request of 128G is not supported and has been omitted.

export PATH=/glade/u/home/gwallach/.conda/envs/goes/bin:$PATH
module load cuda/11 cudnn nccl
python -u goes16_deep_learning_benchmark.py -c benchmark_config_default-Gunther.yml >& goes_deep_default.log

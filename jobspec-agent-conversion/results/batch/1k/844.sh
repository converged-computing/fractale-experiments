#!/bin/bash
#FLUX: --nodes=1
#FLUX: --gpus-per-node=4
#FLUX: --time-limit=1h

# The slurm request for a specific GPU model (v100l) has no analog and was omitted.
# The slurm memory request (--mem) has no analog and was omitted.

module load StdEnv/2023 arrow/15.0.1 rust/1.76.0 python scipy-stack

source ../../test-priv/test-priv-env/bin/activate


python -m src.main --use_yml_config --path_yml_config experiments/WikiText-2/paper/target_whole/generator_generation/less_random_generator/generator_generation.yaml

nvidia-smi

deactivate

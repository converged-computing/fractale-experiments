#!/bin/bash

#FLUX: --job-name=llama2-finetune-7b-hf
#FLUX: --time-limit=2d
#FLUX: --nodes=1
#FLUX: --gpus-per-node=1
#FLUX: --ntasks-per-node=4
#FLUX: --cores-per-task=4
#FLUX: --output=%x.o%j
 
# NOTE: Flux does not support job ID/name specifiers in output paths.

pip install --upgrade pip
module load python/3.11.5

# NOTE: $SLURM_TMPDIR is not available in Flux. A generic temporary path is used instead.
# You may need to change this to a specific scratch filesystem.
TMP_DIR="/tmp/${FLUX_JOB_ID:-$USER-temp}"
mkdir -p "$TMP_DIR"

virtualenv --no-download $TMP_DIR/env
source $TMP_DIR/env/bin/activate

pip install --upgrade pip

module load StdEnv/2023 rust/1.70.0 arrow/14.0.1 gcc/12.3
pip install --no-index torch transformers==4.36.2 peft==0.5.0

echo "=== Fine-tuning Llama2 from job $FLUX_JOB_ID on nodes $(flux resource list)"
python ~/llama2/finetune/eval_7b_hf.py

# Clean up the temporary directory
rm -rf "$TMP_DIR"

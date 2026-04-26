#!/bin/bash
#FLUX: --time-limit=23h59m
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=6
#FLUX: --job-name=trainResNetUlm
#FLUX: --output=output_dir/ResNetUlm/%j-%x.out

# NOTE: Flux does not support job ID/name specifiers in output paths.

cd ~/IFT-6164-ConditionalGenerationUS

module load python/3.9
# module load httpproxy
# module load scipy-stack

# NOTE: $SLURM_TMPDIR is not available in Flux. A generic temporary path is used instead.
# You may need to change this to a specific scratch filesystem.
TMP_DIR="/tmp/${FLUX_JOB_ID:-$USER-temp}"
mkdir -p "$TMP_DIR"

virtualenv --no-download $TMP_DIR/env
source $TMP_DIR/env/bin/activate
pip install --no-index --upgrade pip
pip install --no-index -r requirementsCC.txt

cp -rv ~/scratch/data/data_CGenULM/patchesIQ_small_shuffled $TMP_DIR/
python trainResNetULM.py

# Clean up the temporary directory
rm -rf "$TMP_DIR"

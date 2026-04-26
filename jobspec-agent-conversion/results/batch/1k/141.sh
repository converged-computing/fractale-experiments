#!/bin/bash
#FLUX: --time-limit=2h
#FLUX: --gpus-per-task=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=12

# Path to the compiled image
APPTAINER_IMAGE_PATH=/mnt/parscratch/users/$USER/pytorch-transformers-wikitext2-benchmark/transformers-benchmark-23.07.sif 

# Output the node this was executed on
echo "HOSTNAME=${HOSTNAME}"

# Output some GPU/CPU information into the Log
nvidia-smi
nproc

# Run the benchmark
apptainer run -c -e --bind $(pwd):/mnt --bind ${TMPDIR}:/tmp --env "HF_HOME=/mnt/hf_home/${FLUX_JOB_ID}" --env "TMPDIR=/tmp/${FLUX_JOB_ID}" --nv ${APPTAINER_IMAGE_PATH}


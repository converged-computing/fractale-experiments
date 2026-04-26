#!/bin/bash -l
#FLUX: --ntasks=2
#FLUX: --time-limit=10d
#FLUX: --job-name=nextflow_trim
#FLUX: --output=/proj/fume/nobackup/private/jay/Freshwater_AMR/scripts/process_sites/logs/nextflow_single_asm20230428.log
#FLUX: --error=/proj/fume/nobackup/private/jay/Freshwater_AMR/scripts/amr_finding/logs/nextflow_singleasm202304086.err


cd /proj/fume/nobackup/private/jay/Freshwater_AMR/scripts/process_sites/
module load conda
source conda_init.sh
export CONDA_ENVS_PATH=/proj/fume/nobackup/private/jay/Freshwater_AMR/conda_envs
bash

mamba activate nextflow-22.10.6
nextflow run trim_pipeline.nf -c trim_pipeline.config -resume

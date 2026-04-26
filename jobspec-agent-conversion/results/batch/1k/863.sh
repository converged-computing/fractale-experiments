#!/bin/bash

#FLUX: --time-limit=100h
#FLUX: --job-name=nf_full
#FLUX: --output=slurm_full.out

# The --mem=1GB directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

main_dir='/scratch/yp19/plavskin_seq_analysis'
nf_dir="${main_dir}/nf_scripts"

module purge
module load nextflow/20.10.0
cd $main_dir
nextflow run ${nf_dir}/sra_file_input_pipeline.nf -resume -with-timeline timeline_full.html -with-report report_full.html

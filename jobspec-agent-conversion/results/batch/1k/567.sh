#!/bin/bash
#FLUX: --job-name=NextflowannotationPipeline
#FLUX: --cwd=.
#FLUX: --time-limit=48h1m
#FLUX: --error=err/Nextflow-%J.err
#FLUX: --output=out/Nextflow-%J.out

module load java/1.8.0u66
module load intel/2017.1
module load nextflow/19.03.0

module load singularity/3.2.0


nextflow run /gpfs/projects/bsc83/Projects/Ebola/code/ebola/nextflow_pipelines/05_SC_analysis.nf \
                  --strandness "FR" \
                  --output_dir_name "01_scRNA-Seq_inVivo_rhemac10" \
                  --dataset_bam_dir "/gpfs/projects/bsc83/Data/Ebola/00_RawData/seqwell/data/IRF_SerialSac/Mapping_V4/Mapping_V4" \
                  -w /gpfs/projects/bsc83/Data/Ebola/work/ \
                  -c /gpfs/projects/bsc83/Projects/Ebola/code/ebola/nextflow_pipelines/configs/nextflow.config.sc

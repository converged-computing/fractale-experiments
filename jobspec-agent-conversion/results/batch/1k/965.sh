#! /usr/bin/env bash

#FLUX: --job-name=snake
#FLUX: --output=logs/snake_%J.out
#FLUX: --error=logs/snake_%J.err
#FLUX: --queue=rna

# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.

set -o nounset -o pipefail -o errexit -x

module load fastqc
module load bowtie2
module load samtools
module load subread

mkdir -p logs


# Function to run snakemake
run_snakemake() {
    local snake_file=$1
    local config_file=$2

    # Converted drmaa args for Flux
    args=' 
        -o {log.out} 
        -e {log.err} 
        -J {params.job_name}
        --ntasks={threads}
        -q rna '

    snakemake -n \
        --snakefile $snake_file \
        --drmaa "$args" \
        --jobs 100 \
        --configfiles $config_file
}


# Run pipeline to process mNET-seq reads
pipe_dir=src/pipelines
samples=samples.yaml

snake=$pipe_dir/NETseq.snake
config=NETseq.yaml

run_snakemake $snake "$samples $config"

# Run pipeline to identify pause sites
snake=$pipe_dir/pauses.snake
config=pauses.yaml

run_snakemake $snake "$samples $config"

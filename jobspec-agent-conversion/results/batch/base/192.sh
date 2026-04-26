#! /usr/bin/env bash

#FLUX: --job-name=NET-seq
#FLUX: --output=logs/snake_{flux:id}.out
#FLUX: --error=logs/snake_{flux:id}.err

# NOTE: The LSF job ID variable '%J' was translated to '{flux:id}'.

set -o nounset -o pipefail -o errexit -x

module load fastqc
module load bowtie2
module load samtools
module load subread
module load gcc/7.4.0
module load R/4.0.3

mkdir -p logs


# Function to run snakemake
run_snakemake() {
    local snake_file=$1
    local config_file=$2

    # NOTE: The DRMAA arguments have been converted from LSF to Flux syntax.
    # The memory request 'rusage[mem...]' has been omitted due to no direct Flux equivalent.
    args=' \
        --output={log.out} \
        --error={log.err} \
        --job-name={params.job_name} \
        --nodes=1 \
        --cores={threads} '

    snakemake -n \
        --snakefile $snake_file \
        --drmaa "$args" \
        --jobs 100 \
        --configfiles $config_file
}


# Run pipeline to process mNET-seq reads
pipe_dir=src/pipelines
samples=SAMPLES.yaml

snake=$pipe_dir/NETseq.snake
config=NETseq.yaml

run_snakemake $snake "$samples $config"

# Run pipeline to identify pause sites
snake=$pipe_dir/pauses.snake
config=pauses.yaml

run_snakemake $snake "$samples $config"



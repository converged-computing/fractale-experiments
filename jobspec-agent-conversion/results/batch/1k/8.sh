#!/usr/bin/env bash

#FLUX: --ntasks=1
#FLUX: --time-limit=72h
#FLUX: --output=slurm_%x_%j.out

# The following Slurm directives could not be translated:
# --mem=2G (memory request)
# --export=ALL (environment export)
# --no-requeue (requeue policy)
# --output filename substitutions (%x, %j)

if [[ ! -f ./config.yaml ]]; then
    echo "Must have a config.yaml to be able to run"
    exit 1
fi

source ~/.bashrc.conda #needed to make "conda" command to work
conda activate qiime2-2023.2

set -xeuo pipefail

snakemake --profile ./

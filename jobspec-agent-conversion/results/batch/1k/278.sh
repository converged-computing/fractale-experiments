#!/bin/bash

#FLUX: --job-name=controljob_%j
#FLUX: --output=snakemake_%j.log
# The --partition=vcpu,hpcpu directive is ignored as per instructions.
#FLUX: --time-limit=24h
#FLUX: --cores-per-task=1
#FLUX: --ntasks=1
# The --mem 2000 directive has no direct flux analog and is omitted.

SNAKEMAKE_ENV=snakemake

# Initialize conda:
eval "$(conda shell.bash hook)"
conda activate ${SNAKEMAKE_ENV}

# CRITICAL: This snakemake command is configured to submit jobs to Slurm.
# The --profile ./slurm will need to be changed to a Flux-compatible profile.
snakemake --snakefile workflow/Snakefile \
          --configfile config/config.yaml \
	  --profile ./slurm \
          --rerun-triggers mtime \
          --directory "${PWD}" \
	  "${@}"



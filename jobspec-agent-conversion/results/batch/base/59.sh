#!/bin/bash

#FLUX: --job-name=controljob_{id}
#FLUX: --output=snakemake_{id}.log
#FLUX: --queue=vcpu,hpcpu
#FLUX: --time-limit=24h
#FLUX: --cores-per-task=1
#FLUX: --ntasks=1

# The SLURM --mem directive has no direct Flux analog in the provided documentation.

SNAKEMAKE_ENV=snakemake

# Initialize conda:
eval "$(conda shell.bash hook)"
conda activate ${SNAKEMAKE_ENV}

# CRITICAL: The --profile must be changed from './slurm' to a profile
# configured for Flux job submission.
snakemake --snakefile workflow/Snakefile \
          --configfile config/config.yaml \
	  --profile ./slurm \
          --rerun-triggers mtime \
          --directory "${PWD}" \
	  "${@}"

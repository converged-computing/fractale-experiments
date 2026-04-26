#!/usr/bin/env bash

#FLUX: --job-name=RNAseq
#FLUX: --output=logs/snakemake_{id}.out
#FLUX: --error=logs/snakemake_{id}.err
#FLUX: --queue=rna

# The LSF memory request (-R "select[mem>4] rusage[mem=4]") for this main script
# has no direct Flux analog in the provided documentation.

set -o nounset -o pipefail -o errexit -x

# Load modules
module load singularity/3.9.2

# Flux arguments for sub-jobs. Note the original LSF memory request is omitted.
# CRITICAL: The --drmaa flag is unlikely to work with Flux. You may need to
# change the snakemake call to use `--cluster "flux submit"` and pass these
# arguments as part of that command string.
args=' 
  --queue=rna \
  --output={log}.out \
  --error={log}.err \
  --job-name={params.job_name} \
  --cores={threads} \
  --nodes=1 
' 

# Run snakemake pipeline
snakemake \
    --drmaa "$args" \
    --snakefile Snakefile \
    --configfile config.yaml \
    --jobs 12 \
    --latency-wait 60 \
    --rerun-incomplete \
    --use-singularity \
    --singularity-args "--bind /beevol/home/rbilab --bind /beevol/home/wellskri --bind /beevol/home/wellskri/packages/bin --bind /tmp:/tmp"

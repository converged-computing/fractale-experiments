#!/usr/bin/env bash

#FLUX: --job-name=RNAseq
#FLUX: --output=logs/snakemake.out
#FLUX: --error=logs/snakemake.err

# The LSF memory request (-R "...rusage[mem=4]") could not be translated.
# The dynamic job ID in log files (-o ..._%J.out) is not supported.

set -o nounset -o pipefail -o errexit -x

# Load modules
module load singularity/3.9.2

# CRITICAL: The following snakemake command is INCOMPATIBLE with Flux.
# The '--drmaa' flag and the associated 'args' variable are specific to LSF.
# You must replace this with a Flux-compatible submission method, such as 
# the '--cluster' flag with a 'flux submit' command.
# For example (this is a template, not a guaranteed solution):
# flux_args="flux submit --job-name={params.job_name} -n {threads} --output={log}.out --error={log}.err"
# snakemake --cluster "$flux_args" ...

# Original LSF arguments (for reference, will not work)
args=' 
  -q rna 
  -o {log}.out 
  -e {log}.err 
  -J {params.job_name} 
  -R "{params.memory} span[hosts=1] " 
  -n {threads} ' 

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

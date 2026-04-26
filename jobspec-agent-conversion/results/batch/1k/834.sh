#!/bin/bash

#FLUX: --cores=1
#FLUX: --time-limit=2d

# The --mem and dynamic log filename directives from the original script
# could not be translated.
#FLUX: --output=logs/rc-nonallelespec/snakemake.log
#FLUX: --error=logs/rc-nonallelespec/snakemake.log

module unload python
module load gcc conda2 slurm-drmaa/1.1.1
conda activate rctest

# CRITICAL: The following snakemake command is INCOMPATIBLE with Flux.
# The '--drmaa' flag is specific to Slurm. You must replace it with a 
# Flux-compatible submission method, such as a Snakemake profile for Flux
# or the '--cluster' flag with a 'flux submit' command.
# For example (this is a template, not a guaranteed solution):
# snakemake --cluster "flux submit -N {cluster.nodes} -n {cluster.cores} --mem={cluster.mem} ..."

snakemake \
  --snakefile src/20_62_nonallelespec_rc-test-Snakefile.py \
  --jobs 9980 \
  --restart-times 0 \
  --cluster-config config/rc-test-snakemake-cluster.json \
  --latency-wait 120 \
  --drmaa " -c {cluster.cores} -p {cluster.partition} --mem={cluster.mem} -t {cluster.time} -o {cluster.out} -e {cluster.err} -J {cluster.J}"

conda deactivate

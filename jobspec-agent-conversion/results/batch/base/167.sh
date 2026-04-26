#!/bin/bash

#FLUX: --cores-per-task=1
#FLUX: --queue=priority
#FLUX: --time-limit=2d
#FLUX: --output=logs/rc-nonallelespec/snakemake_{id}.log
#FLUX: --error=logs/rc-nonallelespec/snakemake_{id}.log

# The --mem 4G parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory.
# IMPORTANT: The snakemake --drmaa command below is still configured for SLURM.
# It must be updated if sub-jobs are to be submitted to Flux.

module unload python
module load gcc conda2 slurm-drmaa/1.1.1
conda activate rctest


snakemake \
  --snakefile src/20_62_nonallelespec_rc-test-Snakefile.py \
  --jobs 9980 \
  --restart-times 0 \
  --cluster-config config/rc-test-snakemake-cluster.json \
  --latency-wait 120 \
  --drmaa " -c {cluster.cores} -p {cluster.partition} --mem={cluster.mem} -t {cluster.time} -o {cluster.out} -e {cluster.err} -J {cluster.J}"

conda deactivate

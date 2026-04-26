#!/bin/bash

#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=1d
#FLUX: --output=logs/rc-test_slurm_logs/snakemake.log
#FLUX: --error=logs/rc-test_slurm_logs/snakemake.log


module load gcc conda2 slurm-drmaa/1.1.0
source activate rctest

snakemake \
  --snakefile src/20_20_rc-test-Snakefile \
  --jobs 9950 \
  --restart-times 0 \
  --cluster-config config/rc-test-snakemake-cluster.json \
  --latency-wait 120 \
  --drmaa " --cores-per-task={cluster.cores} --queue={cluster.partition} --time-limit={cluster.time} --output={cluster.out} --error={cluster.err} --job-name={cluster.J}"


# to make a dag
# snakemake \
#   --snakefile src/20_20_rc-test-Snakefile \
#   --dag |  \
#   dot -Tpdf > graphs/20_20_rc-test-Snakefile/dag.pdf



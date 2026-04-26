#!/bin/bash

#FLUX: --job-name=snake
#FLUX: --output=snake.txt
#FLUX: -t 1d
#FLUX: -N 1
#FLUX: -n 1
#FLUX: -c 32

# The SLURM directive '--mem-per-cpu=5G' was omitted as it has no direct Flux translation.
# The SLURM partition directive '--partition=ycga' was ignored as per instructions.

module load miniconda
conda activate isoseq
# The number of cores is hardcoded as Flux does not provide an equivalent to SLURM_CPUS_PER_TASK
snakemake --snakefile isoseq.smk --cores 32 --config species=Cyanea_sp transcriptome=W7.clustered.hq.fasta

#!/bin/bash
## now loop through the above array

#FLUX: --time-limit=10m
#FLUX: --ntasks=2
#FLUX: --nodes=1
#FLUX: --job-name="Prokka"


module load parallel/20180222
module load singularity/3.3.0

sh prokka_genomes.sh 2 221117-1910.P16N-S.16S.dna-sequences.tsv


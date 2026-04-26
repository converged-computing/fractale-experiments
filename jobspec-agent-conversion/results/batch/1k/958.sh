#!/bin/bash
## now loop through the above array

#FLUX: --time-limit=6d23h10m
#FLUX: --ntasks=32
#FLUX: --nodes=1
#FLUX: --job-name="ProkkaP16NS"


module load parallel/20180222
module load singularity/3.3.0

sh prokka_genomes_P16NS.sh 32 221117-1910.P16N-S.16S.dna-sequences.tsv


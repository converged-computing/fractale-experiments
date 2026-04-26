#!/bin/bash
#FLUX: --job-name=unlock_snakemake
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=1
#FLUX: --time=2m


module load tools/miniconda/python3.8/4.9.2
conda activate exonexaminer

snakemake --unlock

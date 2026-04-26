#!/bin/bash
#####  Constructed by HPC everywhere #####
# The --mail-user and --mail-type directives are ignored as per instructions.
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --cores-per-task=23
#FLUX: --time-limit=3d23h59m
#FLUX: --job-name=initnet

######  Module commands #####
source /N/u/baotruon/Carbonate/miniconda3/etc/profile.d/conda.sh
conda activate graph


######  Job commands go below this line #####
cd /N/u/baotruon/Carbonate/marketplace
echo '###### init net ######'
snakemake --nolock --snakefile workflow/rules/initnet.smk --cores 23

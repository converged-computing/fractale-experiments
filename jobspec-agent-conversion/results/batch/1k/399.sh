#!/bin/bash
#FLUX: --time-limit=1h
#FLUX: --output=./slurm/logs/setup/%x-%j.log

# The --mem=1G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.
# The --output directive does not support Slurm-style job name/ID substitution (%x, %j).

# Set up software environment
module load StdEnv/2020   # This is already loaded, but for future compatibility...
module load gcc/9.3.0
#module load kraken2/2.1.1
module load bbmap/38.86
#module load trimmomatic/0.39
#module load blast+/2.12.0
#module load diamond/2.0.13
#module load r/4.1.2
module load python/3.9
export R_LIBS=~/.local/R/$EBVERSIONR/
source ~/env/bin/activate

# Run Snakemake
snakemake -s snakefile_ccmockcomm_step1setup.py -p --cores --configfile configs/mockcomm_step1_setup.yaml

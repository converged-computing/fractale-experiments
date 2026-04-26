#!/bin/bash --login

#FLUX: --job-name=wgs2tree
#FLUX: --ntasks=1
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=1
#FLUX: --time-limit=2h
#FLUX: --output=%x-%j.out
#FLUX: --error=%x-%j.err

# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.

module load singularity/3.11.4-nompi
module load nextflow/23.10.0

# The 'unset SBATCH_EXPORT' command is not relevant in a Flux environment.

nextflow run wgs2tree/main.nf --lineage 'actinopterygii_odb10' --out 'NF'

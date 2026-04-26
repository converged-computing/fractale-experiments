#!/bin/bash

#FLUX: --time-limit=2h
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --job-name="nf-featureCounts"

# Load needed system tools (Java 8 is required, one of singularity or anaconda - python 2.7 is needed,
# depending on the method for dependancy management). The exact names of tool modules might depend on HPC.
module load any/singularity/3.7.3
module load squashfs/4.4

singularity build featureCounts.img docker://quay.io/eqtlcatalogue/rnaseq:v20.11.1

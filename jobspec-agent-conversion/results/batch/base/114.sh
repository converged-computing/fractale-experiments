#!/bin/bash
#
#FLUX: --job-name=meta-TCT-simulations
#FLUX: --ntasks=1
#FLUX: --cores-per-task=72
#FLUX: -t 9h
#FLUX: -q wice
#FLUX: -B lp_doctoralresearch

# NOTE: The Slurm directives for email notification ('--mail-type') were omitted as there are no direct Flux equivalents.
# NOTE: The Slurm cluster directive ('--cluster') was mapped to a Flux queue ('-q').
# NOTE: The Slurm account directive ('-A') was mapped to a Flux bank ('-B').

export OMP_NUM_THREADS=1

module use /apps/leuven/rocky8/icelake/2022b/modules/all
module load GSL
module load CMake
module load  R/4.3.2-foss-2022b

Rscript -e "renv::restore()" -e "Sys.setenv(TZ='Europe/Brussels')"
Rscript colorectal-sensitivity-analysis-relaxed.R 71







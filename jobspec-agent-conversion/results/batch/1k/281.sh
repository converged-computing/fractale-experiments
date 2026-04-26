#!/bin/bash
#FLUX: --job-name=S2
#FLUX: --time-limit=6d
#FLUX: --cc=1-22
#FLUX: --ntasks=1
#FLUX: --nodes=1

# The --mem slurm parameter has no direct analog in flux submit.
# This may affect job scheduling and performance if the job is memory-intensive.

module purge
module load gcc/8.2.0-fasrc01 openmpi/3.1.1-fasrc01
module load intel-mkl/2017.2.174-fasrc01
module load R/3.6.1-fasrc01

export R_LIBS_USER=$HOME/R-3.6.1-MKL
echo $R_LIBS_USER

/n/home05/zilinli/R-3.6.1/bin/Rscript --slave --no-restore --no-save Annotate.R ${FLUX_JOB_CC} > out"${FLUX_JOB_CC}".Rout

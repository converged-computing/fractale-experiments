#!/bin/bash
#FLUX: -J mpi_test
#FLUX: -o mpi_test.out
#FLUX: -e mpi_test.err
#FLUX: -n 8
#FLUX: -t 30m

# The --mem-per-cpu slurm parameter has no direct analog in flux submit.
# This may affect job scheduling and performance if the job is memory-intensive.

# Load required software modules 
module load R/3.5.1-fasrc01
module load gcc/10.2.0-fasrc01 openmpi/4.1.1-fasrc01

# Set up Rmpi package
export R_LIBS_USER=$HOME/apps/R/3.5.1:$R_LIBS_USER
export R_PROFILE=$HOME/apps/R/3.5.1/Rmpi/Rprofile

# Run program
export OMPI_MCA_mpi_warn_on_fork=0
# The --mpi=pmix srun option has no direct flux analog and was omitted.
flux mini run -n 8 R CMD BATCH --no-save --no-restore mpi_test.R

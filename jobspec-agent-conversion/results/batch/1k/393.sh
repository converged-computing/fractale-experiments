#!/bin/bash
# MOAB/Torque submission script for SciNet GPC (hybrid job)
#
#FLUX: --nodes=4
# The ppn=8 (processors per node) is interpreted based on the script's logic:
# 2 MPI tasks per node, each with 4 OpenMP threads (2*4=8).
#FLUX: --tasks-per-node=2
#FLUX: --cores-per-task=4
#FLUX: --time-limit=20m
#FLUX: --job-name=test
# The -m abe (mail) directive is ignored.

# This is an example batch script for the GPC cluster (Nehalem 8CPUs/core)
# This example uses 4 OpenMP threads, 2 MPI per rank and a total number of
# 8 MPI ranks (so in total 4*8=32 CPUs will be used)

# load modules
module load intel/15.0.2 gcc/4.8.1 cmake/3.4.0 intelmpi/5.0.3.048

# Env variables
export F_UFMTENDIAN=big
export KMP_STACKSIZE=1g

# Run dir
# The PBS_O_WORKDIR variable is replaced by FLUX_JOB_CWD
cd $FLUX_JOB_CWD

# Threads
export OMP_NUM_THREADS=4

# Total of MPI ranks requested
export mpi_sum=8

# PIN THE MPI DOMAINS ACCORDING TO OMP
export I_MPI_PIN_DOMAIN=omp

# EXECUTION COMMAND; 
# The mpirun command is replaced with `flux mini run`
# The -ppn and -np flags are not needed as flux manages this from the job spec.
flux mini run ./magic.exe input.nml

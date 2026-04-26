#!/bin/bash
# MOAB/Torque submission script for SciNet GPC (hybrid job)
#
#FLUX: --nodes=4
#FLUX: --cores-per-task=4
#FLUX: --tasks-per-node=2
#FLUX: --time-limit=20m
#FLUX: --job-name=test

# The PBS email notification option '-m abe' has no direct equivalent in flux-submit.

# This is an example batch script for the GPC cluster (Nehalem 8CPUs/core)
# This example uses 4 OpenMP threads, 2 MPI per rank and a total number of
# 8 MPI ranks (so in total 4*8=32 CPUs will be used)

# load modules
module load intel/15.0.2 gcc/4.8.1 cmake/3.4.0 intelmpi/5.0.3.048

# Env variables
export F_UFMTENDIAN=big
export KMP_STACKSIZE=1g

# The cd $PBS_O_WORKDIR command is not needed as Flux jobs start in the submission directory by default

# Threads
export OMP_NUM_THREADS=4

# Total number of MPI ranks is implicitly set by the flux directives
# 4 nodes * 2 tasks/node = 8 tasks (MPI ranks)

# PIN THE MPI DOMAINS ACCORDING TO OMP
export I_MPI_PIN_DOMAIN=omp

# EXECUTION COMMAND; mpirun is replaced with flux run
# The number of tasks (-n 8) and tasks per node (--tasks-per-node 2) are handled by the flux directives.
flux run ./magic.exe input.nml

#!/bin/bash
# FLUX Settings used for all jobs

# The SLURM directive '--mail-type=END' was commented out and ignored.
#FLUX: --job-name=MPI-Correctness-Bench

# The SLURM directive '--mem-per-cpu=3000' was omitted as it has no direct Flux translation.
#FLUX: -t 10m

# Maximum number of threads required for multi-threaded testcases
#FLUX: -c 8

# --ntasks will be specified by the Job Generator Script according to the requirements of each test-case
# --output will also set by the job-script generator

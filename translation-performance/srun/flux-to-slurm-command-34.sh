#!/bin/bash
srun --mpi=pmix --cpu-bind=cores -N4 -n256 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
#!/bin/bash
srun --mpi=pmix --cpu-bind=cores -N1 -n64 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
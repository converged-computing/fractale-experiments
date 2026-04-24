#!/bin/bash
srun --mpi=pmix -N5 -n320 --ntasks-per-node=64 --exclusive --cpu-bind=cores /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
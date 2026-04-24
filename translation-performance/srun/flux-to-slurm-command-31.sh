#!/bin/bash
srun -N1 -n64 --cpu-bind=per-task --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
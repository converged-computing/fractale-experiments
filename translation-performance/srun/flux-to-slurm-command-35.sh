#!/bin/bash
srun --mpi=pmix --cpu-bind=cores -N5 -n320 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
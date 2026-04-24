#!/bin/bash
srun --nodes=5 --ntasks=320 --distribution=block:block --cpu-bind=tasks --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
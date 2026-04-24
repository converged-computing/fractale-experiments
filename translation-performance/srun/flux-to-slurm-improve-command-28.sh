#!/bin/bash
srun --nodes=3 --ntasks=192 --ntasks-per-node=64 --mpi=pmix --cpu-bind=cores --exclusive /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
#!/bin/bash
srun -N 2 -n 2 --cpu-bind=cores --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
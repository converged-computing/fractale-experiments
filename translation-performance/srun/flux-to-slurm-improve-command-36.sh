#!/bin/bash
srun -N2 -n2 --ntasks-per-node=1 --exclusive --spread-job --cpu-bind=core --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
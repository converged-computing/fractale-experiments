#!/bin/bash
srun -N2 -n2 --cpu-bind=task --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency
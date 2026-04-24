#!/bin/bash
srun -N2 -n128 --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
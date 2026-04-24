#!/bin/bash
srun -N5 -n320 --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
#!/bin/bash
srun -N3 -n192 --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
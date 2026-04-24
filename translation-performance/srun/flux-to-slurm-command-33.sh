#!/bin/bash
srun -N3 -n192 --cpu-bind=tasks --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
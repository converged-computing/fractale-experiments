#!/bin/bash
srun --mpi=pmix -N3 -n192 --ntasks-per-node=64 --cpu-bind=tasks --distribution=cyclic:cyclic /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
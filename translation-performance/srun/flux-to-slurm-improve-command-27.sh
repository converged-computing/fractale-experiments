#!/bin/bash
srun -N2 -n128 --ntasks-per-node=64 --mpi=pmix --cpu-bind=cores /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
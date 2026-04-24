#!/bin/bash
srun --mpi=pmix -N2 -n128 --cpu-bind=cores /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
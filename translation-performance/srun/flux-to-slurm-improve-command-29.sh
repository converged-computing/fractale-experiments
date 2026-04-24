#!/bin/bash
srun --nodes=4 --ntasks=256 --mpi=pmix --cpu-bind=cores /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
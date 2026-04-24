#!/bin/bash
srun --mpi=pmix --nodes=1 --ntasks=64 /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
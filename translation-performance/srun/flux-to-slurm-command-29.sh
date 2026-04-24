#!/bin/bash
srun -N4 -n256 --mpi=pmix /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
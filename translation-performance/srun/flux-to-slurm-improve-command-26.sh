#!/bin/bash
srun -N1 -n64 --mpi=pmix --exclusive --cpu-bind=cores --distribution=cyclic:cyclic /usr/local/libexec/osu-micro-benchmarks/mpi/collective/osu_allreduce
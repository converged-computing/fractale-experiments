#!/bin/bash
srun -N1 -n64 --exclusive --cpu-bind=cores --distribution=cyclic:cyclic --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 4 4
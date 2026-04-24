#!/bin/bash
srun -N5 -n320 --cpu-bind=cores --distribution=block:block --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 10
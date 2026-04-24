#!/bin/bash
srun --exclusive -N4 -n256 --ntasks-per-node=64 --cpu-bind=cores --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 8
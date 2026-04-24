#!/bin/bash
srun -N3 -n192 --ntasks-per-node=64 --cpu-bind=cores --mpi=pmix amg -problem 2 -n 90 90 90 -P 3 8 8
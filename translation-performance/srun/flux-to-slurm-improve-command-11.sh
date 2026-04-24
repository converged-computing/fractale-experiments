#!/bin/bash
srun -N2 --ntasks-per-node=64 --cpu-bind=cores --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 4
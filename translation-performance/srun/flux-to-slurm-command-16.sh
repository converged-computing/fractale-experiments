#!/bin/bash
srun --mpi=pmix --cpu-bind=cores -N2 -n128 amg -problem 2 -n 90 90 90 -P 4 8 4
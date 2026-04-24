#!/bin/bash
srun -N4 -n256 --cpu-bind=task --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 8
#!/bin/bash
srun -N2 -n128 --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 4
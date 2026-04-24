#!/bin/bash
srun -N5 -n320 --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 10
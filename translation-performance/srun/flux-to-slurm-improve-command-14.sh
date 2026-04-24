#!/bin/bash
srun --nodes=5 --ntasks=320 --ntasks-per-node=64 --distribution=cyclic:cyclic --exclusive --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 10
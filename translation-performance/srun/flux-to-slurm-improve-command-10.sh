#!/bin/bash
srun --nodes=1 --ntasks=64 --mpi=pmix --exclusive amg -problem 2 -n 90 90 90 -P 4 4 4
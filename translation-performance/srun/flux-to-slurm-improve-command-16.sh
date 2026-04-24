#!/bin/bash
srun --nodes=2 --ntasks-per-node=64 --cpu-bind=verbose,per-task --distribution=cyclic:cyclic --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 4
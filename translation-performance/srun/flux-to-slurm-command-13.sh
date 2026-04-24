#!/bin/bash
srun --nodes=4 --ntasks=256 --mpi=pmix amg -problem 2 -n 90 90 90 -P 4 8 8
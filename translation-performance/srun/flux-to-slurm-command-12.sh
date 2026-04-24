#!/bin/bash
srun -N3 -n192 --mpi=pmix amg -problem 2 -n 90 90 90 -P 3 8 8
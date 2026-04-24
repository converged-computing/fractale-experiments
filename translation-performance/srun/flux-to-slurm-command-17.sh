#!/bin/bash
srun --mpi=pmix --cpu-bind=task -N3 -n192 amg -problem 2 -n 90 90 90 -P 3 8 8
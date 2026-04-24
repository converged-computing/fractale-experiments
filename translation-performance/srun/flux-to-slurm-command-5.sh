#!/bin/bash
srun --mpi=pmix --nodes=1 --ntasks=64 --cpu-bind=per-task lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
#!/bin/bash
srun --mpi=pmix -N 1 -n 64 --cpu-bind=cores lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
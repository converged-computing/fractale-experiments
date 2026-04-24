#!/bin/bash
srun -N3 -n192 --cpu-bind=per-task --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
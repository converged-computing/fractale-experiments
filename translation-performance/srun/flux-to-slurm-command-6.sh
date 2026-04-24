#!/bin/bash
srun -N2 -n128 --cpu-bind=cores --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
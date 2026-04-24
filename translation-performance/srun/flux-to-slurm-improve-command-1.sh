#!/bin/bash
srun -N2 -n128 --ntasks-per-node=64 --mpi=pmix --cpu-bind=cores lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
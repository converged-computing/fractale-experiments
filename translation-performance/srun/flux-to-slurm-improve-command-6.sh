#!/bin/bash
srun --nodes=2 --ntasks=128 --ntasks-per-node=64 --mpi=pmix --cpu-bind=cores lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
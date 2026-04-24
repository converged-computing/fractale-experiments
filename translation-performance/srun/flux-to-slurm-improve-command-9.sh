#!/bin/bash
srun --mpi=pmix --ntasks-per-node=64 --cpu-bind=cores -N5 -n320 lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
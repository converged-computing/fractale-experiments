#!/bin/bash
srun -N1 -n64 --exclusive --hint=nomultithread --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
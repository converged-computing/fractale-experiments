#!/bin/bash
srun --nodes=1 --ntasks=64 --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
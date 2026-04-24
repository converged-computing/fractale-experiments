#!/bin/bash
srun --nodes=2 --ntasks=128 --mpi=pmix lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
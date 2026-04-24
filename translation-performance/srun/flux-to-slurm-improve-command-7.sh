#!/bin/bash
srun --mpi=pmix --hint=nomultithread -N3 -n192 --cpu-bind=cores lmp -v x 20 -v y 20 -v z 20 -in in.reaxff.hns
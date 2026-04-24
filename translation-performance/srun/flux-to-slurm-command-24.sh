#!/bin/bash
srun -N2 -n128 --cpu-bind=task --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,4
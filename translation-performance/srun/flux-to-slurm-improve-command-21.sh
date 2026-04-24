#!/bin/bash
srun -N2 -n128 --exclusive --cpu-bind=cores --distribution=block:block --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,4
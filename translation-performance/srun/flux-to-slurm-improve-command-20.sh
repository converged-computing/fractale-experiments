#!/bin/bash
srun -N1 -n64 --mpi=pmix --cpu-bind=cores --distribution=cyclic:cyclic kripke --niter 100 --zones 64,64,64 --procs 4,4,4
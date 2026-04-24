#!/bin/bash
srun --nodes=1 --ntasks=64 --exclusive --cpu-bind=verbose,cores --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,4,4
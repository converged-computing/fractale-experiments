#!/bin/bash
srun --nodes=4 --ntasks=256 --cpu-bind=cores --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,8
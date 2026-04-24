#!/bin/bash
srun --mpi=pmix -N2 -n128 --distribution=cyclic:cyclic --cpu-bind=cores kripke --niter 100 --zones 64,64,64 --procs 4,8,4
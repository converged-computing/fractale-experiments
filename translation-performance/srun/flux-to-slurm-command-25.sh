#!/bin/bash
srun --mpi=pmix -N4 -n256 --cpu-bind=cores kripke --niter 100 --zones 64,64,64 --procs 4,8,8
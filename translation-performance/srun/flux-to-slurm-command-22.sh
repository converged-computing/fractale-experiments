#!/bin/bash
srun -N4 -n256 --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,8
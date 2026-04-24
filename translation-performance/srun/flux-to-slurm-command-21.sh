#!/bin/bash
srun --nodes=2 --ntasks=128 --mpi=pmix kripke --niter 100 --zones 64,64,64 --procs 4,8,4
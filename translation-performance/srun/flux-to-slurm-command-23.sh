#!/bin/bash
srun --mpi=pmix -N 1 -n 64 --cpus-per-task=1 kripke --niter 100 --zones 64,64,64 --procs 4,4,4
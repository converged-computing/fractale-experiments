#!/bin/bash
#FLUX: --time-limit=5h
#FLUX: --ntasks=10


module load python27-mpi4py/2.0.0
module load miniconda2
# 'mpirun' is replaced with 'flux run'
flux run -n 10 python capm.py

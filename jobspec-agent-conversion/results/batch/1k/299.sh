#!/bin/bash

#FLUX: --ntasks=4
#FLUX: --job-name=gwecc-search


# module load pkgsrc/2022Q2

/home/susobhan/Data/susobhan/miniconda/envs/gwecc/bin/activate

PYTHON=$CONDA_PREFIX/bin/python
JULIA=$PYTHON_JULIACALL_BINDIR/julia

source print_info.sh
mpichversion | head -n 1
$PYTHON -c 'from mpi4py import MPI, __version__ as mpi_ver; print("mpi4py version", mpi_ver)'

echo

# 'mpirun' is replaced with 'flux run'
flux run -n 4 $PYTHON run_1psr_analysis.py fix-wn_vary-rn_vary-ecw.json

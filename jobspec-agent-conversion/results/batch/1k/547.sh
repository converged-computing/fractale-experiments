#!/bin/sh
#
#FLUX: --job-name=perf_cylinder_3D
#FLUX: --time-limit=2d
#FLUX: --ntasks=4
#FLUX: --output=stdout/slurm-%J.out
#FLUX: --error=stdout/slurm-%J.err

source ../compile/modules_snellius.sh

# The original 'mpiexecjl' command has been replaced with the standard Flux launcher 'flux mini run'.
flux mini run -n 4 julia -J ../PerforatedCylinder_parallel.so -O3 --check-bounds=no -e 'include("run_3Dcase.jl")'

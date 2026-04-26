#!/bin/sh
#SBATCH
#FLUX: --job-name=bistable
#FLUX: --time-limit=2h
#FLUX: --ntasks=1
#FLUX: --nodes=1
#FLUX: --cores-per-task=8

# module load julia
julia  -e 'using Pkg; Pkg.activate("projects/bistable")'        -e 'include("projects/bistable/src/run_count_lengths.jl")'        -O3 --banner=no $@



#!/bin/bash 
#FLUX: --ntasks=40
#FLUX: --job-name=spatialR
#FLUX: --output=%x-%j.o
#FLUX: --error=%x-%j.e
#FLUX: --time-limit=3h59m59s


# NOTE: The %x and %j format specifiers are not supported in Flux; files will be overwritten.

module purge
module load julia/1.5.0

# NOTE: The logic for generating a SLURM_NODEFILE has been removed.
# The Julia application is now launched with 'flux run'.
flux run -n 40 julia ~/SpatialRust/scripts/ParamScan5.jl

cp /scratch/mvanega1/track05/* ~/SpatialRust/results/track05/
rm /scratch/mvanega1/track05/*

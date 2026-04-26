#!/bin/bash
#FLUX: --ntasks=5
#FLUX: --job-name=CVs
#FLUX: --time-limit=1h
#FLUX: -o logs/shading/o-%A.o
#FLUX: -e logs/shading/o-%A.e


# NOTE: The %A format specifier is not supported in Flux; files will be overwritten.


module purge
module load julia/1.8.2

echo `date +%F-%T`
echo $FLUX_JOB_ID
echo $(flux resource list)
# NOTE: The logic for generating a SLURM_NODEFILE has been removed.
# The Julia application is now launched with 'flux run'.
flux run -n 5 julia \
~/SpatialRust/scripts/ShadingExperiments/calcRepCVs.jl 600 22.0 0.8 0.7 4

#!/bin/bash
#FLUX: --ntasks-per-core=1
#FLUX: --ntasks=5
#FLUX: --job-name=shadeexp
#FLUX: --time-limit=4h

#FLUX: -o logs/shading/exp-%A-%a.o
#FLUX: -e logs/shading/exp-%A-%a.e

# NOTE: The %A and %a format specifiers are not supported in Flux; files will be overwritten.


module purge
module load julia/1.8.2

# NOTE: The logic for generating a SLURM_NODEFILE has been removed.
# The Julia application is now launched with 'flux run'.
echo `date +%F-%T`
echo $FLUX_JOB_ID
echo $(flux resource list)

# NOTE: This script is a job array. The SLURM_ARRAY_TASK_ID variable has been
# replaced with FLUX_JOB_CC. You must submit this job with 'flux submit --cc=1-4 ...'
flux run -n 5 julia \
~/SpatialRust/scripts/ShadingExperiments/runExperiment.jl 50 22.0 0.8 0.7 $FLUX_JOB_CC 5
#ARGs: repetitions, mean temp, rain prob, wind prob, array ID -> shade_placements, sim years

#!/bin/bash
#FLUX: --job-name=test_pipeline
#FLUX: --time-limit=10h
#FLUX: --cc=1-195

# The --mem slurm parameter has no direct analog in flux submit.
# This may affect job scheduling and performance if the job is memory-intensive.

# Slurm's dynamic output filename (%a) is not supported in Flux directives.
# We redirect all output for the script using 'exec' and the FLUX_JOB_CC variable.
exec > /home/belv1601/scratch/output/out/quebec/${FLUX_JOB_CC}.out 2>&1

module use /home/belv1601/.local/easybuild/modules/2020/avx2/Compiler/gcc9/
module load StdEnv/2020  gcc/9.3.0 r-inla/21.05.02 geos/3.9.1 gdal/3.0.4 proj/7.0.1 udunits

# SLURM_ARRAY_TASK_ID is replaced by FLUX_JOB_CC
sp=$(cut -d' ' -f${FLUX_JOB_CC} data/species_vect.txt)
make spatial zone=south_qc species=$sp cpu_task=1 output_dir=/home/belv1601/scratch/output obs_folder=data/occurrences
make models zone=south_qc species=$sp cpu_task=1 output_dir=/home/belv1601/scratch/output
make maps zone=south_qc species=$sp cpu_task=1 output_dir=/home/belv1601/scratch/output
make binary_maps zone=south_qc species=$sp cpu_task=1 output_dir=/home/belv1601/projects/def-dgravel/belv1601/sdm/output

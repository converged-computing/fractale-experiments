#!/bin/bash
#FLUX: --job-name=search_5
#FLUX: --nodes=20
#FLUX: --tasks-per-node=1
#FLUX: --cores-per-task=10
#FLUX: --time-limit=3d

# Slurm's dynamic output/error filenames (%j) are not supported in Flux directives.
# We redirect the output in the script body using the FLUX_JOB_ID variable instead.

module purge
module load gcc/7.4.0
module load openmpi
module load cmake

cd /global/scratch/users/pierrj/PAV_SV/PAV/raxml_ng_test

# Ensure output/error directories exist
mkdir -p /global/home/users/pierrj/slurm_stdout
mkdir -p /global/home/users/pierrj/slurm_stderr

flux mini run -n 20 /global/scratch/users/pierrj/raxml_ng_savio1/bin/raxml-ng-mpi --msa savio1_T1.raxml.rba --prefix search_5 --threads 10 --extra thread-pin --seed 55555 > /global/home/users/pierrj/slurm_stdout/slurm-${FLUX_JOB_ID}.out 2> /global/home/users/pierrj/slurm_stderr/slurm-${FLUX_JOB_ID}.out

#!/bin/bash
#FLUX: --time-limit=24h
#FLUX: --job-name=pico
#FLUX: --error=./pico.err.{id}
#FLUX: --output=./pico.out.{id}
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: --nodes=1
#FLUX: --exclusive
#FLUX: --requires=avx

# The --mail-user and --mail-type parameters from slurm have no direct equivalent in flux-submit.
# You will not receive email notifications for this job.
# The --mem-per-cpu=8182 parameter from slurm has no direct equivalent in flux-submit.
# The job may be scheduled on a node without enough memory (approx. 128GB was requested).

# ----------------------------------


module load intel python/3.6.8
python -u ./src/run_pico_experiments.py

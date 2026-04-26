#!/bin/bash
#FLUX: --queue=general-compute
#FLUX: --time-limit=12h
#FLUX: --job-name=Distribution_plots
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --output=logs_bismark/{job-name}.{id}.out
#FLUX: --error=logs_bismark/{job-name}.{id}.err

# The SLURM --mem directive has no direct Flux analog in the provided documentation.
# The SLURM --requeue directive has no direct Flux analog.

#module load gcc
module load R/3.5.1

cd /projects/rpci/joyceohm/pnfioric/PDX_RRBS_Processing/Code
Rscript 04_distribution_plots_for_samples.R

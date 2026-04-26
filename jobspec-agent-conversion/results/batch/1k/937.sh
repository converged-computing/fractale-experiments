#!/bin/bash
#FLUX: --job-name=Distribution_plots
#FLUX: --time-limit=12h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=4
#FLUX: --output=logs_bismark/Distribution_plots.{id}.out
#FLUX: --error=logs_bismark/Distribution_plots.{id}.err

module load R/3.5.1

cd /projects/rpci/joyceohm/pnfioric/PDX_RRBS_Processing/Code
Rscript 04_distribution_plots_for_samples.R

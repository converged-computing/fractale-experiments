#!/bin/bash
#FLUX: --job-name=recon1_emt_a549_quantile
#FLUX: --output=./recon1_quantile_output.log
#FLUX: --error=./recon1_quantile_error.err
#FLUX: --nodes=1
#FLUX: --tasks-per-node=8
#FLUX: --time-limit=1d

module load matlab/R2018b
module load gurobi/9.1.1
matlab -nodisplay -r "run('/home/scampit/Turbo/scampit/Software/emt-cobra/notebooks/matlab/06_old/quantile_cobra_simulations.m'); exit"

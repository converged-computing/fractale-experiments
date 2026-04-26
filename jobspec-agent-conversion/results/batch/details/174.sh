#!/bin/bash

# Copy/paste this job script into a text file and submit with the command:
#    flux submit ./thefilename
# job standard output will go to the file specified in the --output directive.

#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=18
#FLUX: --job-name="glap_bol_lin"
#FLUX: --output="laporta_grid_study_nvib_bolsig_linear.out"

# The SLURM directive '--mem=8G' could not be translated.

module load matlab/R2022a
module load intel
export omp_num_threads=8
cd /home/lynch/boltzmann_solvers/mtmhbe_solver/performance/laporta/grid_study/nvib_sweep_data/
matlab -nodisplay -nosplash -nodesktop -r "laporta_bolsig_linear;exit;"

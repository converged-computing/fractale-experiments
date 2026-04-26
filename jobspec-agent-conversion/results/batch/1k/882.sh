#!/bin/bash

#Submit this script with: sbatch thefilename

#FLUX: --time-limit=1h
#FLUX: --nodes=1
#FLUX: --tasks-per-node=18
#FLUX: --ntasks=18
#FLUX: --job-name="glap_bol_auto"
#FLUX: --output="laporta_grid_study_nvib_bolsig_auto.out"



module load matlab/R2022a
module load intel
export omp_num_threads=8
cd /home/lynch/boltzmann_solvers/mtmhbe_solver/performance/laporta/grid_study/nvib_sweep_data/
matlab -nodisplay -nosplash -nodesktop -r "laporta_bolsig_auto;exit;"

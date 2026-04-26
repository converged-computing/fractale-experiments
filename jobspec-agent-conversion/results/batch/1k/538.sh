#!/bin/bash
#
#FLUX: --job-name=sim_proc
#FLUX: --time-limit=10h
#FLUX: --ntasks=1
#FLUX: --cwd=/proj/hs_micro_div_072022
#FLUX: --output=./Reports/output_{id}.out
#FLUX: --error=./Reports/error_{id}.err
#
# Run a single task in the foreground.
module load buildtool-easybuild/4.5.3-nsce8837e7
module load foss/2020b
module load Anaconda/2021.05-nsc1
conda activate ds-envsci-env
python "/home/x_swakh/tools/HoliSoils/Scripts/Linux/transient/Simulation_processing/simulation_proc.py" "competition_adaptation"
# Scripts ends here

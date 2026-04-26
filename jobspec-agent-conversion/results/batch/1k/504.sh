#!/bin/bash
#FLUX: --ntasks=4
#FLUX: --nodes=1
#FLUX: --job-name=tedana_22
#FLUX: --error=errorfiles/tedana_22
#FLUX: --output=outfiles/tedana_22


##########################################################
# Set up environmental variables.
##########################################################
export NPROCS=$FLUX_NTASKS
export OMP_NUM_THREADS=$NPROCS

. $MODULESHOME/../global/profile.modules

##########################################################
##########################################################
source /home/data/nbc/data-analysis/py3_environment

python run_reliability_workflows.py 22



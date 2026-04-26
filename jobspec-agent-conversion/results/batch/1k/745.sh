#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --job-name=DCCR-7
#FLUX: --output=/home/sap625/logs/out/%j.out
#FLUX: --error=/home/sap625/logs/err/%j.err
#FLUX: --time-limit=24h

# Variables, directories, etc.
PROJECT_DIR=$HOME/dev/DCCR
VENV_DIR=$HOME/envs/l2m
JULIA_BIN=$HOME/julia

# Date and current folder
date
ls -la

# Activate the virtual environment for the project
# source activate $VENV_DIR
source $VENV_DIR/bin/activate

# Run the full experiment from one Julia script
$JULIA_BIN $PROJECT_DIR/src/experiments/10_l2m_dist/3_dist_driver.jl

# End with echoes
echo --- END OF CUDA CHECK ---
echo All is quiet on the western front

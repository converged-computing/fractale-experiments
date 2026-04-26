#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=24
#FLUX: --time-limit=4h
#FLUX: --output=/mnt/lustre/users/blombard/reinfectionsBelinda/oe_files/lamdba2.out
#FLUX: --error=/mnt/lustre/users/blombard/reinfectionsBelinda/oe_files/lambda2.err

# The -P, -q, -m, and -M directives were ignored as per instructions.

ulimit -s unlimited

# module add chpc/R/3.5.1-gcc7.2.0
module add chpc/BIOMODULES R/4.1.0

cd /mnt/lustre/users/blombard/reinfectionsBelinda

# Run program
make run infections=3

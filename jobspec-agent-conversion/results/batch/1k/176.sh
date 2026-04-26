#!/bin/bash
#
#FLUX: --job-name=sMD
#FLUX: --ntasks=1
#FLUX: --tasks-per-node=8
#FLUX: --gpus-per-task=1
#FLUX: --cwd=/work/slough_md12_scratch/ahardie
#FLUX: --output=lsf.%J.out
#FLUX: --error=lsf.%J.err


# NOTE: The %J format specifier is not supported in Flux; files will be overwritten.
# NOTE: Memory requests and complex resource constraints are not supported.

cd /work/slough_md12_scratch/ahardie
#source /home/model/MD-SOFTWARE/amber18-gnu-cu10/amber.sh
source /home/model/MD-SOFTWARE/plumed-2.6.1/sourceme.sh
source /home/model/MD-SOFTWARE/BSSenv-new.bashrc

/home/e628835/software/sire.app/bin/python 01_run_sMD.py --topology system.prm7 --coordinates system.rst7 --reference reference.pdb --residues 179-185 --steering_runtime 150 --total_runtime 152 --force 3500

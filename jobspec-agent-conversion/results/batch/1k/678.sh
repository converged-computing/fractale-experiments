#!/bin/sh
#FLUX: --job-name=twist2Of4
#FLUX: --time-limit=2h
#FLUX: --cores-per-task=6
#FLUX: --gpus-per-task=1
#FLUX: --cwd=/home/santamgp/Documents/CertifyingAffineTransformationsOnPointClouds/3D-RS-PointCloudCertifying/
#FLUX: --output=logs/%x_%A_%a.out
#FLUX: --error=logs/%x_%A_%a.err
#FLUX: --cc=7-12
#FLUX: --requires=v100

# The --mem=40GB directive has no direct analog in the provided flux submit options.
# The --output and --error directives do not support Slurm-style substitutions (%x, %A, %a).

module load gcc

echo "######################### SLURM JOB ########################"
echo HOST NAME
echo `hostname`
echo "############################################################"

environment=CertifyingPointClouds
conda_root=$HOME/anaconda3

source $conda_root/etc/profile.d/conda.sh
conda activate $environment

set -ex

# ------------------------ need not change -----------------------------------

LINE=$(sed -n "$((${FLUX_JOB_CC}))"p scripts/AllTwisting.txt)
python3 Certify.py  $LINE 

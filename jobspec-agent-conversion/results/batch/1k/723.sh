#!/bin/bash
#FLUX: --job-name="eq"
#FLUX: --ntasks=1
#FLUX: --gpus-per-task=1
#FLUX: --time-limit=3h
#FLUX: --output=out_%J_%I.stdout
#FLUX: --error=out_%J_%I.stderr

# The following LSF directives could not be translated:
# -R rusage[mem=8] (memory)
# -R span[hosts=1] (resource span)
# -gpu j_exclusive=yes:mode=shared (GPU mode)
# -sp 1 (priority)
# -o/-eo filename substitutions (%J, %I)

source ~/.bashrc
OPENMM_CPU_THREADS=1
#export OE_LICENSE=~/.openeye/oe_license.txt   # Open eye license activation/env

# chnage dir
# The job will start in the submission directory by default.


# Report node in use
echo "======================"
hostname
env | sort | grep 'CUDA'
nvidia-smi
echo "======================"


# run job
conda activate openmmforcefields-dev

script_path=/home/takabak/data/exploring-rna/rna-espaloma/experiment/tetramer/script
python ${script_path}/openmm_eq_amber.py -i ../../crd/rna_noh.pdb --water_model "opc" --output_prefix .

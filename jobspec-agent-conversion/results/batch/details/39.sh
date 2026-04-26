#!/bin/bash
#FLUX: --job-name=petscDMDA
#FLUX: --nodes=1
#FLUX: --ntasks=4
# The --hint=nomultithread directive has no direct flux analog and is omitted.
# Flux can control affinity with, e.g., -o cpu-affinity=per-task
#FLUX: --time-limit=10m
#FLUX: --output=petscDMDA%j.out
#FLUX: --error=petscDMDA%j.out

# on se place dans le répertoire de soumission
# The SLURM_SUBMIT_DIR variable is replaced by FLUX_JOB_CWD
cd ${FLUX_JOB_CWD}

# nettoyage des modules charges en interactif et herites par defaut
module purge

# chargement des modules
source ../../../petsc.sh

# echo des commandes lancées
set -x

# exécution du code
# The srun command is replaced by `flux mini run`
time flux mini run ./dmda.exe -da_grid_x 1000 -da_grid_y 1000 -ksp_type cg -pc_type hypre

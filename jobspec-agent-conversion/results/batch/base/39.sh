#!/bin/bash
#FLUX: --job-name=petscDMDA
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --time-limit=10m
#FLUX: --output=petscDMDA{id}.out
#FLUX: --error=petscDMDA{id}.out

# The SLURM '--hint=nomultithread' directive has no direct Flux analog.

# on se place dans le répertoire de soumission
# Flux jobs start in the submission directory by default.

# nettoyage des modules charges en interactif et herites par defaut
module purge

# chargement des modules
source ../../../petsc.sh

# echo des commandes lancées
set -x

# exécution du code
# The srun command is replaced by flux mini run.
time flux mini run -n 4 ./dmda.exe -da_grid_x 1000 -da_grid_y 1000 -ksp_type cg -pc_type hypre

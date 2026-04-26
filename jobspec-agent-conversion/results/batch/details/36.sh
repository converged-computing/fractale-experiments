#!/bin/sh
#FLUX: --job-name=ideal_fire
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --output=ideal_fire.out
#FLUX: --error=ideal_fire.err
#FLUX: --time-limit=10m

# Echo des commandes
ulimit -c 0
ulimit -s unlimited
# Arrete du job des la premiere erreur
set -e
# Nom de la machine
hostname 

. ~rodierq/DEV_57/MNH-PHYEX070-b95d84d7/conf/profile_mesonh-LXifort-R8I4-MNH-V5-6-2-ECRAD140-MPIAUTO-O2

# The original script used a custom MPIRUN variable. This has been replaced
# with the standard 'flux run' command.
# export MPIRUN="Mpirun -np 1"

set -x
set -e

ls -lrt

rm -f FIRE_LES.??? FIRE_PGD.???
time flux run -n 1 PREP_IDEAL_CASE${XYZ}
mv OUTPUT_LISTING1  OUTPUT_LISTING1_ideal
 
touch FIRE_PGD.des
ls -lrt 

rm -f file_for_xtransfer pipe_name

ls -lrt 

# CRITICAL: The original script's final action was to submit another job.
# This is not translatable. The contents of 'run_mesonh' should be placed here.
# sbatch run_mesonh

# The 'ja' command from the original script was not a standard command and has been removed.
# ja

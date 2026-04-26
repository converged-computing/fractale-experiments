#!/bin/sh
#FLUX: --job-name=ideal_fire
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --time-limit=10m
#FLUX: --output=ideal_fire.eo${FLUX_JOB_ID}
#FLUX: --error=ideal_fire.eo${FLUX_JOB_ID}

# Echo des commandes
ulimit -c 0
ulimit -s unlimited
# Arrete du job des la premiere erreur
set -e
# Nom de la machine
hostname

. ~rodierq/DEV_57/MNH-PHYEX070-b95d84d7/conf/profile_mesonh-LXifort-R8I4-MNH-V5-6-2-ECRAD140-MPIAUTO-O2

set -x
set -e


ls -lrt

rm -f FIRE_LES.??? FIRE_PGD.???
# Using 'flux run' is the recommended way to launch tasks under Flux
time flux run -n 1 PREP_IDEAL_CASE${XYZ}
mv OUTPUT_LISTING1  OUTPUT_LISTING1_ideal

touch FIRE_PGD.des
ls -lrt

rm -f file_for_xtransfer pipe_name

ls -lrt

# The 'sbatch' command is converted to 'flux submit'.
flux submit run_mesonh

# The 'ja' command from the original script has no known Flux equivalent and has been removed.

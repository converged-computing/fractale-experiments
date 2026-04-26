#!/bin/sh
#FLUX: --job-name=tools
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --output=tools.eo%j
#FLUX: --error=tools.eo%j
#FLUX: --time-limit=2h

# Echo des commandes
ulimit -c 0
ulimit -s unlimited
# Arrete du job des la premiere erreur
set -e

. ~rodierq/DEV_57/MNH-PHYEX070-b95d84d7/conf/profile_mesonh-LXifort-R8I4-MNH-V5-6-2-ECRAD140-MPIAUTO-O2
ln -sf ${SRC_MESONH}/src/LIB/Python/* .
ln -sf ~rodierq/SAVE/OUTILS/PYTHON/departements-20180101.* .
ln -sf ../007_run/AZF02.*.CEN4T.*.nc .
module purge
module load python/3.7.6

python3 plot_AZF2M.py
convert *.png AZF_2M.pdf

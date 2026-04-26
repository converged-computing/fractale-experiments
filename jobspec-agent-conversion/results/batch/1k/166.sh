#!/bin/sh
#FLUX: --job-name=tools
#FLUX: --nodes=1
#FLUX: --ntasks=1
#FLUX: --output=tools.out
#FLUX: --error=tools.err
#FLUX: --time-limit=1h

# Echo des commandes
ulimit -c 0
ulimit -s unlimited
# Arrete du job des la premiere erreur
set -e

. ~rodierq/DEV_57/MNH-PHYEX070-b95d84d7/conf/profile_mesonh-LXifort-R8I4-MNH-V5-6-2-ECRAD140-MPIAUTO-O2

ln -sf ${SRC_MESONH}/src/LIB/Python/* .

module purge
module load python/3.7.6

python3 plot_16JAN.py
convert *.png 16JAN.pdf

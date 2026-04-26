#!/bin/sh
#FLUX: --job-name=HAICprep
#FLUX: --nodes=1
#FLUX: --ntasks=16
#FLUX: --output=POI16.eo{flux:jobid}
#FLUX: --error=POI16.eo{flux:jobid}
#FLUX: -t 1h
#FLUX: -q normal256

# NOTE: The SLURM partition directive '-p' was translated to the Flux queue directive '-q'.
# NOTE: The MPI launch command has been updated from a custom 'Mpirun' variable to the native 'flux mini run'.

# Echo des commandes
ulimit -c 0
ulimit -s unlimited
# Nom de la machine
hostname 

. ~rodierq/DEV_57/MNH-PHYEX070-b95d84d7/conf/profile_mesonh-LXifort-R8I4-MNH-V5-6-2-ECRAD140-MPIAUTO-O2-HAIC

ln -sf ../01_prep_pgd/PGD.* .
ln -sf ~/SAVE/mesonh/PGD/pgd_guyane* .
ln -sf ~/SAVE/GRIB_KTEST/arome.FO.201505* .
ln -sf ~/SAVE/GRIB_KTEST/historic.20150529.00.lfi

touch pgd_guyane.02km50.04.des
touch historic.20150529.00.des

time flux mini run -n 16 PREP_REAL_CASE${XYZ}

for i in 00 06 12 18 24; do
    cp PRE_REAL1.nam_$i PRE_REAL1.nam
    time flux mini run -n 16 PREP_REAL_CASE${XYZ}
done
cd ../
./run_all_mesonh

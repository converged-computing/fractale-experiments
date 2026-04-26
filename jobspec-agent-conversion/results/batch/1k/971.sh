#!/bin/bash
#
#     Arno Behrens (May 2019)
#
#==>  WAM post-processing pspec
#
#FLUX: --job-name=pspec
#FLUX: --ntasks=1
#FLUX: --tasks-per-node=1
#FLUX: --time-limit=5m
#FLUX: --output=pspec.o%j
#FLUX: --error=pspec.e%j
#
module load compilers/intel/2019.4.243
module load intelmpi/2019.4.243
module load netcdf
#
set -k
WAMDIR=/gpfs/home/ricker/WAM/WAM_Cycle7_test
WORK=/gpfs/work/ricker/storage/WAM/WAM_Cycle7_test
#
cd ${WORK}/tempsg
cp ${WAMDIR}/const/Spectra_User .
cp ${WAMDIR}/abs/pspec pspec.exe
#
./pspec.exe
#
mv Spectra_Prot ${WAMDIR}/dayfiles/pspec_prot_coarse_ST6
rm Spectra_User pspec.exe
#
# ===================================================================
#  GRID FILES HAVE BEEN CREATED AND SAVED.
#  END OF JOB PGRID.
# ===================================================================
#

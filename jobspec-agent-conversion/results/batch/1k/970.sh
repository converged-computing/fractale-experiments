#!/bin/bash
#
#==>  WAM post-processing ptime
#
#     Arno Behrens (September 2019)
#
#FLUX: --job-name=ptime
#FLUX: --nodes=1
#FLUX: --ntasks-per-node=1
#FLUX: --time=5m

# Slurm's dynamic output/error filenames (%j) are not supported in Flux directives.
# We redirect all output for the script using 'exec' and the FLUX_JOB_ID variable.
exec > ptime.o${FLUX_JOB_ID} 2> ptime.e${FLUX_JOB_ID}
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
cp ${WAMDIR}/const/Time_User .
cp ${WAMDIR}/abs/ptime ptime.exe
#
./ptime.exe
mv Time_Prot ${WAMDIR}/dayfiles/ptime_prot_coarse_ST6
rm Time_User ptime.exe 
#
# ===================================================================
#  GRID FILES HAVE BEEN CREATED AND SAVED.
#  END OF JOB PTIME.
# ===================================================================
#

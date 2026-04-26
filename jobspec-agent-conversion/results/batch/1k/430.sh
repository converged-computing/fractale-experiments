#!/bin/bash
######################################################
#FLUX: --job-name=EasyBuild
#FLUX: --time-limit=6h
#FLUX: --ntasks=1
#FLUX: --cores-per-task=4
#FLUX: --cwd=/sNow/easybuild/jobs


######################################################
## Call the Easy Build 
# srun is not required for a single task job in Flux
eb  GROMACS-4.6.5-ictce-5.5.0-mt.eb --try-toolchain=ictce,5.4.0 --robot --force
# srun is not required for a single task job in Flux
eb WRF-3.4-goalf-1.1.0-no-OFED-dmpar.eb -r
######################################################
## Update the LMOD cache
/sNow/apps/lmod/utils/BuildSystemCacheFile/createSystemCacheFile.sh

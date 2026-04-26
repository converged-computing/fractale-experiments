#!/bin/bash
#FLUX: --job-name=DST_FC
#FLUX: --nodes=1
#FLUX: --cores=24


cd /brain/iCAN/home/tianyanqiu/SPM12_scripts/Preprocessing/DSTFC

matlab -r "DSTFC_Preprocessing"

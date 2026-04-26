#!/bin/bash -l
#FLUX: --job-name="alf_NGC4365_SN100"
#FLUX: --cwd="/cosma5/data/durham/dc-poci1/alf/NGC4365"
#FLUX: --time-limit=2d
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: --cc=0-330

source ${HOME}/.bashrc

module load gnu_comp
module load python/3.10.7
module load openmpi/20190429
module load cmake/3.18.1
export ALF_HOME=/cosma5/data/durham/dc-poci1/alf/

cd ${ALF_HOME}
declare idx=$(printf %04d $((${FLUX_JOB_CC} + 1320)))
flux mini run -n 16 ./NGC4365/bin/alf.exe "NGC4365_SN100_${idx}" 2>&1 | tee -a "NGC4365/out_${idx}.log"

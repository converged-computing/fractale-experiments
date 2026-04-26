#!/bin/bash

#FLUX: --job-name=orca_run
#FLUX: --nodes=1
#FLUX: --ntasks=4
#FLUX: --tasks-per-node=4

export MODULEPATH=/opt/easybuild/modules/all
module load ORCA/4.2.1-gompi-2019a
export OMP_NUM_THREADS=4
ulimit -n 4096
echo "Starting run"

#job id to create temporary directory
ID=$FLUX_JOB_ID
#create temp directory in scratch
mkdir /scratch/${ID}
## copy the files in work directory to temporary directory
shopt -s extglob
cp -r ./!(slurm*.out) /scratch/${ID}/
shopt -u extglob
#change to temp directory
cd /scratch/${ID}

# orca run
export ORCA_BIN=`which orca`
export ORCA_2MKL_BIN=`which orca_2mkl`
$ORCA_BIN orca_atom.inp > orca_atom.out
# create molden file
$ORCA_2MKL_BIN orca_atom -molden


# job finished copy back
cp -r * ./
cd ${HOME}
## delete temp. directory
rm -rf /scratch/${ID}



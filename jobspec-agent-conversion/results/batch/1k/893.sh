#!/bin/bash
#FLUX: --job-name=job-name
#FLUX: --nodes=1
#FLUX: --ntasks=40
#FLUX: --time-limit=15d
#FLUX: --gpus-per-node=1


#for cuda queue
module load centos7.3/app/namd/2017-11-10-multicore-cuda


echo "FLUX_NODELIST $FLUX_NODELIST"
echo "NUMBER OF CORES $FLUX_NTASKS"

$NAMD_DIR/namd2  +p $FLUX_NTASKS  +idlepoll config.conf

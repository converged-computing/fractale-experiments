#!/bin/bash
#
#FLUX: --job-name=ssn_workers
#FLUX: --output=ssn_workers.log
#FLUX: --ntasks=4
#FLUX: --time-limit=1h
#FLUX: --cores-per-task=2



CONTAINER=/cluster/kappa/90-days-archive/wongjiradlab/larbys/images/singularity-ssnetserver/singularity-ssnetserver-caffelarbys-cuda8.0.img

WORKDIR=/usr/local/ssnetserver
#WORKDIR=/cluster/kappa/wongjiradlab/twongj01/ssnetserver

# IP ADDRESSES OF BROKER
BROKER=10.246.81.73 # PGPU03
# BROKER=10.X.X.X # ALPHA001

PORT=5560

#GPU_ASSIGNMENTS=/cluster/kappa/wongjiradlab/twongj01/ssnetserver/grid/gpu_assignments.txt
GPU_ASSIGNMENTS=${WORKDIR}/grid/gpu_assignments.txt

module load singularity
# NOTE: This script is a job array. You must submit it with 'flux submit --cc=0-3 ...'
singularity exec --nv ${CONTAINER} bash -c "cd ${WORKDIR}/grid && ./run_caffe1worker.sh ${WORKDIR} ${BROKER} ${PORT} ${GPU_ASSIGNMENTS}"

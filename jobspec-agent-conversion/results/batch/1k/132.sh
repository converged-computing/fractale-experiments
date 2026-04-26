#!/bin/bash -l
#FLUX: --nodes=1
#FLUX: --time-limit=1h
#FLUX: --job-name=cice-qc
#FLUX: --output=log-cice-qc.o
#FLUX: --error=log-cice-qc.e

# The 'cd $SLURM_SUBMIT_DIR' line was removed as Flux jobs typically
# start in the directory from which they are submitted.
export OMP_NUM_THREADS=1

source /lcrc/soft/climate/e3sm-unified/load_latest_e3sm_unified_chrysalis.sh

export HDF5_USE_FILE_LOCKING=FALSE

export BASE=/lcrc/group/acme/ac.dcomeau/scratch/chrys/20221218.DMPAS-JRA1p5.TL319_EC30to60E2r2.chrysalis.column-package.intel/run
export TEST=/lcrc/group/acme/ac.dcomeau/scratch/chrys/20221218.DMPAS-JRA1p5.TL319_EC30to60E2r2.chrysalis.icepack.intel/run

# The 'srun' command has been replaced with 'flux run'.
flux run -N 1 -n 1 python mpas-seaice.t-test.py $BASE $TEST

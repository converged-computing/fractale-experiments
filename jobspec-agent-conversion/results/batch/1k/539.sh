#!/bin/bash
#FLUX: --nodes=1
#FLUX: --ntasks=12
#FLUX: --time-limit=8h
#FLUX: --job-name=zipCode_adder

# The PBS memory request (-l mem) has no direct analog in flux and has been omitted.
# The PBS directive to join output/error streams (-j oe) has no analog and was omitted.

module purge

SRCDIR=$HOME/project/Most-hapennning-places-NYC/
# PBS's $PBS_JOBID is replaced by Flux's $FLUX_JOB_ID
RUNDIR=$SCRATCH/Most-hapennning-places-NYC/run-${FLUX_JOB_ID}
mkdir -p $RUNDIR

# PBS's $PBS_O_WORKDIR is replaced by Flux's $FLUX_SUBMIT_DIR
cd $FLUX_SUBMIT_DIR
cp -R $SRCDIR/* $RUNDIR

cd $RUNDIR

module load virtualenv/12.1.1;
module load scipy/intel/0.16.0
module load geos/intel/3.4.2

virtualenv .venv

source .venv/bin/activate;

pip install shapely
pip install geopy

cd src/nyctaxi

python zip_adder.py

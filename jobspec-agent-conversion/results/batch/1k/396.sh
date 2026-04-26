#!/bin/bash
#FLUX: --nodes=1
#FLUX: --cores=1
#FLUX: --time-limit=10m
#FLUX: --cc=1-2

module load java
module load julia

JULIA_DIR=/work/yalexand/OPT_JULIA/JULIA

SRC_DIR=/work/yalexand/TestData
DST_DIR=/work/yalexand

fname=fluor.OME.tiff

# The PBS job array variable $PBS_ARRAY_INDEX has been replaced with the Flux equivalent $FLUX_JOB_CC
fname=$(head -n $FLUX_JOB_CC $SRC_DIR/filelist.txt | tail -1 )
 
cd $JULIA_DIR

src=$SRC_DIR/$fname
dst=$DST_DIR/reconstr_$fname
julia OPT_reconstruction_test_nix.jl $src $dst

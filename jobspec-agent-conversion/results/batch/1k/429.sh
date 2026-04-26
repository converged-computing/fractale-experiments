#!/bin/bash
# LAMMPS SubmitScript
# Optimized for run parallel job of 1024 Cores 
######################################################
#FLUX: --job-name=LAMMPS
#FLUX: --time-limit=30m
#FLUX: --ntasks=128
#FLUX: --cores-per-task=8

# The --mem-per-cpu=4G directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

######################################################
###  Load the Environment
module load lammps
######################################################
###  The files will be allocated in the shared FS 
cd $SCRATCH_DIR
cp -pr /sNow/test/LAMMPS/* .
######################################################
###  Run the Parallel Program
#Lennard Jones Benchmark input parameters: Weak Scaling
lmp_mpi -var x 10 -var y 40 -var z 40 -in in.lj
######################################################
###  Transferring the results to the home directory
cp -pr $SCRATCH_DIR $HOME/OUT/lammps/

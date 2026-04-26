#!/bin/bash

#FLUX: --ntasks=16
#FLUX: --cores-per-task=1
#FLUX: --time-limit=3h
#FLUX: --job-name=Lammps-Test
#FLUX: --input=lammps.in
#FLUX: --output=lammps_lj_output.txt

# The --mem-per-cpu=1500M directive has no direct analog in the provided flux submit options.
# This may impact job scheduling and resource allocation.

# Load the modules:

module load intel/2019.5 ompi/3.1.4 lammps/29Sep21

echo "Starting run at: `date`"

lmp_exec=lmp_grex

${lmp_exec}

echo "Program finished with exit code $? at: `date`"

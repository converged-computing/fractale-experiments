#!/bin/bash --login

#FLUX: --job-name=eq_
#FLUX: --nodes=4
#FLUX: --tasks-per-node=2
#FLUX: --ntasks=8
#FLUX: --time-limit=24h
#FLUX: --error=./equil.pbs.err
#FLUX: --output=./equil.pbs.out

module load namd2

NAME="solv"
PSFFILE=""

# NOTE: Flux jobs start in the submission directory ($PBS_O_WORKDIR) by default.

# Define a temporary directory. $PBS_TMPDIR is not available in Flux.
# You may need to change this to a specific scratch filesystem.
TMP_DIR="/tmp/${FLUX_JOB_ID:-$USER-temp}"
mkdir -p "$TMP_DIR"


# Copy working files to the temporary directory
for x in namdinclude.tcl clusters_new.par CHARMM_22prot_27lip.par
do
   cp ~/NAMD/common/$x "$TMP_DIR"
done
cp equilibrate.namd ${NAME}eq_in.* $PSFFILE "$TMP_DIR"

# Change to the temporary directory
cd "$TMP_DIR"
chmod 400 clusters_new.par

# Run NAMD using 'flux run'
flux run -n 8 namd2 equilibrate.namd >> "$SUBMIT_DIR"/${NAME}eq_out.log

# Copy output files to the original submission directory
# Assuming SUBMIT_DIR is where you submitted the job from.
# Flux does not have a direct equivalent for $PBS_O_WORKDIR, but this is the common behavior.
SUBMIT_DIR=$(pwd) 
cp *_out.* "$SUBMIT_DIR"

# Clean up the temporary directory
rm -rf "$TMP_DIR"

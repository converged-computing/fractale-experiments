#!/bin/bash

#FLUX: --job-name=test_job
#FLUX: --nodes=1
#FLUX: --ntasks=8
#FLUX: --time-limit=96h
#FLUX: --output=test_job_out.txt
#FLUX: --cwd=.

echo $SLURM_SUBMIT_DIR
echo $infile $seed $T $P $rcut $tstep
module load lammps/3Aug2022
module avail
lmp -in $infile -var seed $seed -var T $T -var P $P -var rcut $rcut -var tstep $tstep

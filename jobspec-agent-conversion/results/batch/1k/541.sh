#!/bin/bash
#FLUX: --job-name=Si_phonts_LAMMPS_P
#FLUX: --ntasks=16
#FLUX: --time-limit=48h
#FLUX: --output=job.out
#FLUX: --error=job.err

echo "Flux Job ID: $FLUX_JOB_ID"
echo "Job Name: Si_phonts_LAMMPS_P"
echo "Node List: $(flux resource list)"
echo "Total Tasks: 16"
echo "Working Directory: $(pwd)"
echo "Hostname: $(hostname)"
echo "Start Time: $(date)"

module load intel/2016.0.109
module load openmpi/1.10.2

# The srun command has been replaced with the standard Flux launcher 'flux mini run'.
flux mini run -n 16 PhonTS > phonts.std.out

touch jobCompleted
echo "End Time: $(date)"

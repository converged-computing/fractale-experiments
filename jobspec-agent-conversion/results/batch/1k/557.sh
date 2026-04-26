#!/bin/env bash
#
#FLUX: --ntasks=1
#FLUX: --time-limit=500m
#FLUX: --output=/scratch/zmd/logs/orient.out
#FLUX: --error=/scratch/zmd/logs/orient.err

module load anacondapy/5.3.1
source activate lightsheet

echo "In the directory: `pwd` "
echo "As the user: `whoami` "
echo "on host: `hostname` "

cat /proc/$$/status | grep Cpus_allowed_list

python fix_orientation_and_rerun_registration.py

# Usage notes:
# after = go once the specified job starts
# afterany = go if the specified job finishes, regardless of success
# afternotok = go if the specified job fails
# afterok = go if the specified job completes successfully



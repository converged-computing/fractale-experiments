#!/usr/bin/env bash

# No Flux resource directives were added as none were specified in the original Slurm script.
# The job will run with the system's default resource allocation.
# Slurm directives for partition, mail, and output file mode were ignored as per instructions.

set -e
module load gcc/6.2.0
module load python/3.6.0
source /home/al311/python_3.6.0/bin/activate

python -u ../scripts/MI07A_Select_best.py $1 $2 && echo "PYTHON SCRIPT COMPLETED"

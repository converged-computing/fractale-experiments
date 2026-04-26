#!/bin/bash
#
#FLUX: --job-name=dfc645
#FLUX: --output=dfc645_job.out
#FLUX: --ntasks=1
#FLUX: --cores-per-task=16
#FLUX: --time-limit=14h

# load your Anaconda module here and activate your virtual environment (if needed)
set -e
source /home/ashovon/newaumri/matfiles/venv/bin/activate


# execute your python scripts (change it to whatever it needs to be for you).
python -u /home/ashovon/newaumri/matfiles/TemporalBrainPH/distance_calculation.py --data 645 --method ws --start 1 --end 316 --distance y --mds y


